

import { SignJWT, createRemoteJWKSet, jwtVerify } from "npm:jose@5";

/** معرّف مشروع Firebase (من google-services.json). */
const FIREBASE_PROJECT_ID = "emtilak-app-2026";

/** issuer/id_token المطلوبان لتوكنات Firebase لهذا المشروع. */
const FIREBASE_ISSUER = `https://securetoken.google.com/${FIREBASE_PROJECT_ID}`;

/** مفاتيح عامة RSA العامة لتوكنات Firebase — تُجلب وتُخزَّن تلقائيًا. */
const FIREBASE_JWKS = createRemoteJWKSet(
  new URL(
    "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com",
  ),
);

/** عمر JWT المُصدَّر: ساعة واحدة (العميل يجدّده قبل انتهائه). */
const TOKEN_TTL_SECONDS = 3600;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method !== "POST") {
    return json({ error: "method_not_allowed" }, 405);
  }

  // 1) استقبال توكن Firebase (Bearer <ID Token>) من التطبيق.
  const authorization = req.headers.get("Authorization") ?? "";
  const firebaseIdToken = authorization.startsWith("Bearer ")
    ? authorization.slice(7)
    : "";
  if (!firebaseIdToken) {
    return json({ error: "missing_firebase_token" }, 401);
  }

  // 2) التحقق من التوكن: التوقيع (مفاتيح Google) + issuer + audience.
  let uid: string;
  let email: string | null = null;
  let name: string | null = null;
  try {
    const { payload } = await jwtVerify(firebaseIdToken, FIREBASE_JWKS, {
      issuer: FIREBASE_ISSUER,
      audience: FIREBASE_PROJECT_ID,
    });
    if (typeof payload.sub !== "string" || payload.sub.length === 0) {
      return json({ error: "missing_subject" }, 401);
    }
    uid = payload.sub;
    email = typeof payload.email === "string" ? payload.email : null;
    name = typeof payload.name === "string" ? payload.name : null;
  } catch (error) {
    console.error("firebase-session: Firebase token verification failed", error);
    return json({ error: "invalid_firebase_token" }, 401);
  }

  // 3) إصدار JWT لـ Supabase: sub = Firebase UID (سرّ التوقيع خادمي فقط).
  const jwtSecret = Deno.env.get("EMTILAK_JWT_SECRET");
  if (!jwtSecret) {
    // تشخيص جذري ذاتي: نسجّل حالة المفتاح وأسماء مفاتيح البيئة المرتبطة
    // بـ JWT/Emtilak (أسماء فقط — لا قيم إطلاقًا) حتى تكشف سجلّات الدالة
    // السبب الحقيقي: مفتاح مفقود، أم محفوظ باسم مختلف، أم موجود وفارغ.
    try {
      const envKeys = Object.keys(Deno.env.toObject());
      const related = envKeys.filter((k) => /jwt|emtilak/i.test(k));
      const status = envKeys.includes("EMTILAK_JWT_SECRET")
        ? "EXISTS_BUT_EMPTY"
        : "MISSING";
      console.error(
        `firebase-session: EMTILAK_JWT_SECRET ${status}; related env keys: [${
          related.join(", ")
        }]`,
      );
    } catch (introspectError) {
      console.error(
        "firebase-session: env introspection failed",
        introspectError,
      );
    }
    return json({ error: "server_misconfigured" }, 500);
  }

  try {
    const supabaseJwt = await new SignJWT({
      role: "authenticated",
      email,
      app_metadata: { provider: "firebase", providers: ["firebase"] },
      user_metadata: name ? { full_name: name, name } : {},
      aal: "aal1",
      ref: "ozsgjxyovhvivreuojfv",
      aud: "authenticated",
    })
      .setProtectedHeader({ alg: "HS256" })
      .setSubject(uid) // هنا تحدث المعجزة: profiles.id == Firebase UID
      .setIssuer("supabase")
      .setIssuedAt()
      .setExpirationTime(`${TOKEN_TTL_SECONDS}s`)
      .sign(new TextEncoder().encode(jwtSecret));

    return json({ token: supabaseJwt, expires_in: TOKEN_TTL_SECONDS });
  } catch (error) {
    console.error("firebase-session: JWT signing failed", error);
    return json({ error: "signing_failed" }, 500);
  }
});

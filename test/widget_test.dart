import 'package:flutter_test/flutter_test.dart';

import 'package:emtilak/app/app.dart';

void main() {
  testWidgets('يعرض وينقل بين صفحات Onboarding الثلاث', (WidgetTester tester) async {
    await tester.pumpWidget(const EmtilakApp());

    expect(find.text('تقارير دقيقة و واضحة'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(find.text('تتبع الإيرادات والمدفوعات'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(find.text('إدارة عقاراتك بسهولة'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}

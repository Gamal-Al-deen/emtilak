import 'package:flutter_test/flutter_test.dart';

import 'package:emtilak/app/app.dart';

void main() {
  testWidgets('يعرض وينقل بين صفحات Onboarding الثلاث', (WidgetTester tester) async {
    await tester.pumpWidget(const EmtilakApp());

    expect(find.text('تقارير دقيقة و واضحة'), findsOneWidget);
    expect(find.text('ابدأ الآن'), findsOneWidget);

    await tester.tap(find.text('ابدأ الآن'));
    await tester.pumpAndSettle();

    expect(find.text('تتبع الإيرادات والمدفوعات'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(find.text('إدارة عقاراتك بسهولة'), findsOneWidget);
    expect(find.text('أضف مبانيك ووحداتك وتابع حالة كل وحدة\nمن مكان واحد بكل سهولة.'), findsOneWidget);
    expect(find.text('التالي'), findsOneWidget);
  });
}

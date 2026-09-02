import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime(2024, 5, 1),
    end: DateTime(2024, 5, 31),
  );

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _selectedRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final startStr =
        '${_selectedRange.start.day.toString().padLeft(2, '0')}/${_selectedRange.start.month.toString().padLeft(2, '0')}/${_selectedRange.start.year}';
    final endStr =
        '${_selectedRange.end.day.toString().padLeft(2, '0')}/${_selectedRange.end.month.toString().padLeft(2, '0')}/${_selectedRange.end.year}';

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'التقارير المالية'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: ResponsiveContainer(
          maxWidth: 1200,
          child: Column(
            children: [
              // Interactive Date Filter Box
              GestureDetector(
                onTap: () => _selectDateRange(context),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        '$startStr - $endStr',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Stat Cards (1 row of 4 on wide screen, 2 rows of 2 on mobile)
              if (isWide)
                Row(
                  children: [
                    Expanded(
                      child: _buildReportCard(
                        title: 'إجمالي المحصل',
                        value: '23,600 \$',
                        valueColor: AppColors.rented,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportCard(
                        title: 'إجمالي المستحقات',
                        value: '28,500 \$',
                        valueColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportCard(
                        title: 'نسبة التحصيل',
                        value: '82%',
                        valueColor: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportCard(
                        title: 'المتأخرات',
                        value: '4,900 \$',
                        valueColor: AppColors.error,
                      ),
                    ),
                  ],
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildReportCard(
                        title: 'إجمالي المحصل',
                        value: '23,600 \$',
                        valueColor: AppColors.rented,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportCard(
                        title: 'إجمالي المستحقات',
                        value: '28,500 \$',
                        valueColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildReportCard(
                        title: 'نسبة التحصيل',
                        value: '82%',
                        valueColor: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildReportCard(
                        title: 'المتأخرات',
                        value: '4,900 \$',
                        valueColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

              // Revenue chart card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الإيرادات خلال الفترة المحددة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: isWide ? 220 : 150,
                      child: Center(
                        child: CustomPaint(
                          size: Size(double.infinity, isWide ? 200 : 120),
                          painter: MockChartPainter(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}

class MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.7)
      ..lineTo(size.width * 0.4, size.height * 0.3)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

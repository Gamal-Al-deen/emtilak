import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/common/custom_app_bar.dart';
import 'report_filter_row.dart';
import 'report_summary_card.dart';
import 'report_chart_section.dart';
import 'report_table_section.dart';

class FinancialReportContent extends StatefulWidget {
  const FinancialReportContent({super.key});

  @override
  State<FinancialReportContent> createState() => _FinancialReportContentState();
}

class _FinancialReportContentState extends State<FinancialReportContent> {
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
              ReportFilterRow(
                startStr: startStr,
                endStr: endStr,
                onTap: () => _selectDateRange(context),
              ),
              const SizedBox(height: 20),
              ReportSummaryCard(isWide: isWide),
              const SizedBox(height: 20),
              ReportChartSection(isWide: isWide),
              const ReportTableSection(),
            ],
          ),
        ),
      ),
    );
  }
}

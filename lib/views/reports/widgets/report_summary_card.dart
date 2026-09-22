import 'package:flutter/material.dart';
import '../../../core/colors.dart';

class ReportSummaryCard extends StatelessWidget {
  final bool isWide;

  const ReportSummaryCard({
    super.key,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'إجمالي المحصل',
              value: '23,600 \$',
              valueColor: AppColors.rented,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'إجمالي المستحقات',
              value: '28,500 \$',
              valueColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'نسبة التحصيل',
              value: '82%',
              valueColor: AppColors.gold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              title: 'المتأخرات',
              value: '4,900 \$',
              valueColor: AppColors.error,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'إجمالي المحصل',
                value: '23,600 \$',
                valueColor: AppColors.rented,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
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
              child: _buildStatCard(
                title: 'نسبة التحصيل',
                value: '82%',
                valueColor: AppColors.gold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'المتأخرات',
                value: '4,900 \$',
                valueColor: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
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

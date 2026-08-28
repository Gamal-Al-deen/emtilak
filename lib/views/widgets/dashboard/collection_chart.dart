import 'package:flutter/material.dart';
import '../../../app/colors.dart';

class CollectionChart extends StatelessWidget {
  final double collectedRatio; // e.g. 0.83
  final double delayedRatio; // e.g. 0.12
  final double pendingRatio; // e.g. 0.05

  const CollectionChart({
    super.key,
    this.collectedRatio = 0.83,
    this.delayedRatio = 0.12,
    this.pendingRatio = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'نظرة عامة',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Circular representation
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: collectedRatio,
                        strokeWidth: 10,
                        backgroundColor: AppColors.divider,
                        color: AppColors.success,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(collectedRatio * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Text(
                          'نسبة التحصيل',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem(
                      'مدفوع',
                      '${(collectedRatio * 100).toInt()}%',
                      AppColors.success,
                    ),
                    const SizedBox(height: 6),
                    _buildLegendItem(
                      'متأخر',
                      '${(delayedRatio * 100).toInt()}%',
                      AppColors.info,
                    ),
                    const SizedBox(height: 6),
                    _buildLegendItem(
                      'قيد التحصيل',
                      '${(pendingRatio * 100).toInt()}%',
                      AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
        const Spacer(),
        Text(
          percent,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

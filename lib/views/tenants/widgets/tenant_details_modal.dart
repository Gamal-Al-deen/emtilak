import 'package:flutter/material.dart';
import '../../../../core/colors.dart';
import '../../../../utils/responsive.dart';
import '../../../../models/app_models.dart';

class TenantDetailsModal extends StatelessWidget {
  final Tenant tenant;
  final VoidCallback onViewStatement;

  const TenantDetailsModal({
    super.key,
    required this.tenant,
    required this.onViewStatement,
  });

  @override
  Widget build(BuildContext context) {
    final t = tenant;
    return ResponsiveContainer(
      maxWidth: 550,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.divider,
                    radius: 22,
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          t.unitName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 18, color: AppColors.divider),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'رقم الهاتف:',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    t.phone,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (t.nationalId.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'رقم الهوية:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      t.nationalId,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: onViewStatement,
                icon: const Icon(Icons.receipt_long, size: 18),
                label: const Text(
                  'عرض كشف الحساب التفصيلي',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

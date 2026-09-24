import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/dashboard/stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final int buildingsCount;
  final int unitsCount;
  final int rentedCount;
  final int vacantCount;

  const DashboardStatsGrid({
    super.key,
    required this.buildingsCount,
    required this.unitsCount,
    required this.rentedCount,
    required this.vacantCount,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(context);

    final int statCrossAxisCount;
    final double statAspectRatio;
    if (Responsive.isDesktop(context) || Responsive.isLargeDesktop(context)) {
      statCrossAxisCount = 4;
      statAspectRatio = 2.4;
    } else if (Responsive.isTablet(context)) {
      statCrossAxisCount = 4;
      statAspectRatio = 2.0;
    } else {
      statCrossAxisCount = 2;
      statAspectRatio = 2.0;
    }

    return GridView.count(
      crossAxisCount: statCrossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: isWide ? 16 : 12,
      mainAxisSpacing: isWide ? 16 : 12,
      childAspectRatio: statAspectRatio,
      children: [
        StatCard(
          title: 'المباني',
          value: '$buildingsCount',
          icon: Icons.apartment,
          iconColor: AppColors.gold,
        ),
        StatCard(
          title: 'الوحدات',
          value: '$unitsCount',
          icon: Icons.grid_view_rounded,
          iconColor: Theme.of(context).colorScheme.primary,
        ),
        StatCard(
          title: 'المؤجرة',
          value: '$rentedCount',
          icon: Icons.key,
          iconColor: AppColors.rented,
        ),
        StatCard(
          title: 'الفارغة',
          value: '$vacantCount',
          icon: Icons.home_outlined,
          iconColor: AppColors.vacant,
        ),
      ],
    );
  }
}

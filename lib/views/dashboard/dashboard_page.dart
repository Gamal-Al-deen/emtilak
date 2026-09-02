import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
import '../../mockData/mock_data_service.dart';
import '../../routes/routes.dart';
import '../../widgets/dashboard/stat_card.dart';
import '../../widgets/dashboard/collection_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final MockDataService _dataService = MockDataService.instance;

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final buildingsCount = _dataService.totalBuildingsCount;
    final unitsCount = _dataService.totalUnitsCount;
    final rentedCount = _dataService.rentedUnitsCount;
    final vacantCount = _dataService.vacantUnitsCount;
    final totalIncome = _dataService.totalIncomeCollected;
    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    // Responsive cross-axis count & aspect ratio
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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      child: ResponsiveContainer(
        maxWidth: 1400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Welcome Header Card (Adaptive layout for wide screens)
            _buildWelcomeCard(context, totalIncome, isWide),
            const SizedBox(height: 20),

            // Stat Cards (2 columns on mobile, 4 columns on wide screens)
            GridView.count(
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
                  iconColor: AppColors.primary,
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
            ),
            const SizedBox(height: 20),

            // Collection Ratio Chart and Quick Actions
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Collection Chart takes 60% of wide screen
                  const Expanded(
                    flex: 3,
                    child: CollectionChart(
                      collectedRatio: 0.83,
                      delayedRatio: 0.12,
                      pendingRatio: 0.05,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Quick Actions Card takes 40% of wide screen
                  Expanded(
                    flex: 2,
                    child: _buildWideQuickActions(context),
                  ),
                ],
              )
            else ...[
              // Stacked vertically on Mobile
              const CollectionChart(
                collectedRatio: 0.83,
                delayedRatio: 0.12,
                pendingRatio: 0.05,
              ),
              const SizedBox(height: 20),
              _buildMobileQuickActions(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Welcome banner that adapts cleanly between mobile and wide screens
  Widget _buildWelcomeCard(BuildContext context, double totalIncome, bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 24 : 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isWide
          ? Row(
              children: [
                // Profile & Greeting on left side
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.white24,
                        child: Icon(
                          Icons.person,
                          color: AppColors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'مرحباً بك',
                              style: TextStyle(
                                color: AppColors.white70,
                                fontSize: 13,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              'أحمد محمد',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'لوحة إدارة العقارات الذكية',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 12,
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
                ),
                const SizedBox(width: 20),
                // Income banner on right side
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'إجمالي التدفق المحصل',
                                style: TextStyle(
                                  color: AppColors.white70,
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${totalIncome.toInt()} \$',
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                '12.5%+ عن الشهر الماضي',
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 11,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.show_chart,
                          color: AppColors.gold,
                          size: 48,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'مرحباً بك',
                            style: TextStyle(
                              color: AppColors.white70,
                              fontSize: 12,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            'أحمد محمد',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.white24,
                      child: Icon(
                        Icons.person,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Income banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'إجمالي التدفق المحصل',
                              style: TextStyle(
                                color: AppColors.white70,
                                fontSize: 11,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${totalIncome.toInt()} \$',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '12.5%+ عن الشهر الماضي',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 10,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.show_chart,
                        color: AppColors.gold,
                        size: 42,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// Mobile quick action cards
  Widget _buildMobileQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPayment);
            },
            icon: const Icon(Icons.add_card, size: 18),
            label: const Text(
              'تسجيل دفعة',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addContract);
            },
            icon: const Icon(
              Icons.note_add_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            label: const Text(
              'عقد جديد',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Wide screen quick actions card
  Widget _buildWideQuickActions(BuildContext context) {
    return Container(
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
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPayment);
            },
            icon: const Icon(Icons.add_card, size: 20),
            label: const Text(
              'تسجيل دفعة جديدة',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addContract);
            },
            icon: const Icon(Icons.note_add_outlined, color: AppColors.primary, size: 20),
            label: const Text(
              'إنشاء عقد جديد',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addMaintenance);
            },
            icon: const Icon(Icons.build_outlined, color: AppColors.textSecondary, size: 20),
            label: const Text(
              'تسجيل مصروف صيانة',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

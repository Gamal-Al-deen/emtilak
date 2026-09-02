import 'package:flutter/material.dart';
import '../../core/colors.dart';
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Owner Welcome Header Card (Matches Image 1)
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                const SizedBox(height: 20),
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
                      Column(
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
                          Text(
                            '${totalIncome.toInt()} \$',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
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
                      const Icon(
                        Icons.show_chart,
                        color: AppColors.gold,
                        size: 48,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4 Grid Stat Cards (Buildings, Units, Rented, Vacant - Matches Image 1)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
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

          // Collection Ratio Chart
          const CollectionChart(
            collectedRatio: 0.83,
            delayedRatio: 0.12,
            pendingRatio: 0.05,
          ),
          const SizedBox(height: 20),

          // Quick Action Cards
          Row(
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
          ),
        ],
      ),
    );
  }
}

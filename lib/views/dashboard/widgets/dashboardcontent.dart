import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';
import '../../../mockData/mock_data_service.dart';
import '../../../widgets/dashboard/collection_chart.dart';
import 'dashboard_welcome_card.dart';
import 'dashboard_stats_grid.dart';
import 'dashboard_quick_actions.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
      child: ResponsiveContainer(
        maxWidth: 1400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardWelcomeCard(
              totalIncome: totalIncome,
              isWide: isWide,
            ),
            const SizedBox(height: 20),
            DashboardStatsGrid(
              buildingsCount: buildingsCount,
              unitsCount: unitsCount,
              rentedCount: rentedCount,
              vacantCount: vacantCount,
            ),
            const SizedBox(height: 20),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: CollectionChart(
                      collectedRatio: 0.83,
                      delayedRatio: 0.12,
                      pendingRatio: 0.05,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    flex: 2,
                    child: DashboardWideQuickActions(),
                  ),
                ],
              )
            else ...[
              const CollectionChart(
                collectedRatio: 0.83,
                delayedRatio: 0.12,
                pendingRatio: 0.05,
              ),
              const SizedBox(height: 20),
              const DashboardMobileQuickActions(),
            ],
          ],
        ),
      ),
    );
  }
}

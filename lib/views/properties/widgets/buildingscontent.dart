import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import '../../../utils/responsive.dart';
import '../../../mockData/mock_data_service.dart';
import '../../../models/app_models.dart';
import '../../../routes/routes.dart';
import 'building_card.dart';
import 'add_building_dialog.dart';
import 'buildings_empty_state.dart';
import 'buildings_search_bar.dart';

class BuildingsContent extends StatefulWidget {
  const BuildingsContent({super.key});

  @override
  State<BuildingsContent> createState() => _BuildingsContentState();
}

class _BuildingsContentState extends State<BuildingsContent> {
  final MockDataService _dataService = MockDataService.instance;
  String _searchQuery = '';

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

  void _showAddBuildingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddBuildingDialog(
          onSubmit: ({
            required String name,
            required String location,
            required int totalUnits,
          }) {
            _dataService.addBuilding(
              name: name,
              location: location,
              totalUnits: totalUnits,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة المبنى بنجاح!'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allBuildings = _dataService.buildings;
    final filteredBuildings = _searchQuery.isEmpty
        ? allBuildings
        : allBuildings
            .where(
              (b) =>
                  b.name.contains(_searchQuery) ||
                  b.location.contains(_searchQuery),
            )
            .toList();

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              BuildingsSearchBar(
                onSearchChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                onAddPressed: _showAddBuildingDialog,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredBuildings.isEmpty
                    ? const BuildingsEmptyState()
                    : isWide
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isDesktop(context) ||
                                      Responsive.isLargeDesktop(context)
                                  ? 3
                                  : 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: filteredBuildings.length,
                            itemBuilder: (context, index) {
                              return _buildCardFor(filteredBuildings[index]);
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredBuildings.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildCardFor(filteredBuildings[index]),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFor(Building b) {
    final buildingUnits = _dataService.getUnitsForBuilding(b.name);
    final total = buildingUnits.isNotEmpty ? buildingUnits.length : b.totalUnits;
    final rented = buildingUnits.where((u) => u.status == 'مؤجرة').length;
    final vacant = buildingUnits.where((u) => u.status == 'فارغة').length;

    return BuildingCard(
      building: b,
      totalUnits: total,
      rentedUnits: rented,
      vacantUnits: vacant,
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.unitsGrid,
          arguments: b.name,
        );
      },
    );
  }
}

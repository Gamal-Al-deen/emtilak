import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';
import '../../../controllers/app_controllers.dart';
import '../../../models/app_models.dart';
import '../../../routes/routes.dart';
import 'contract_details_modal.dart';
import 'contract_card.dart';
import 'contracts_empty_state.dart';
import 'contracts_search_bar.dart';

class ContractsContent extends StatefulWidget {
  const ContractsContent({super.key});

  @override
  State<ContractsContent> createState() => _ContractsContentState();
}

class _ContractsContentState extends State<ContractsContent> {
  final AppControllers _dataService = AppControllers.instance;
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

  @override
  Widget build(BuildContext context) {
    final allContracts = _dataService.contracts;
    final filteredContracts = _searchQuery.isEmpty
        ? allContracts
        : allContracts
            .where(
              (c) =>
                  c.tenantName.contains(_searchQuery) ||
                  c.unitName.contains(_searchQuery) ||
                  c.id.contains(_searchQuery),
            )
            .toList();

    final isWide = Responsive.isWide(context);
    final horizontalPadding = Responsive.getHorizontalPadding(context);

    final double gridAspectRatio;
    if (Responsive.isLargeDesktop(context)) {
      gridAspectRatio = 1.9;
    } else if (Responsive.isDesktop(context)) {
      gridAspectRatio = 1.75;
    } else {
      gridAspectRatio = 1.6;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ResponsiveContainer(
        maxWidth: 1400,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: [
              ContractsSearchBar(
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredContracts.isEmpty
                    ? const ContractsEmptyState()
                    : isWide
                        ? GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isDesktop(context) ||
                                      Responsive.isLargeDesktop(context)
                                  ? 3
                                  : 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: gridAspectRatio,
                            ),
                            itemCount: filteredContracts.length,
                            itemBuilder: (context, index) {
                              return ContractCard(
                                contract: filteredContracts[index],
                                onTap: () => _openContractDetails(
                                  context,
                                  filteredContracts[index],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: filteredContracts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ContractCard(
                                  contract: filteredContracts[index],
                                  onTap: () => _openContractDetails(
                                    context,
                                    filteredContracts[index],
                                  ),
                                ),
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

  void _openContractDetails(BuildContext context, Contract c) {
    ContractDetailsModal.show(
      context,
      contract: c,
      onViewStatement: () {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          AppRoutes.tenantStatement,
          arguments: c.tenantName,
        );
      },
      onAddPayment: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoutes.addPayment);
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../routes/routes.dart';
import '../../views/contracts/contracts_page.dart';
import '../../views/dashboard/dashboard_page.dart';
import '../../views/properties/buildings_page.dart';
import '../../views/tenants/tenants_page.dart';
import '../../views/transactions/payments_page.dart';
import '../common/custom_app_bar.dart';
import '../common/main_drawer.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    BuildingsPage(),
    ContractsPage(),
    PaymentsPage(),
    TenantsPage(),
  ];

  final List<String> _titles = const [
    'لوحة التحكم',
    'المباني',
    'العقود',
    'الدفعات',
    'المستأجرون',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.notifications);
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.shifting,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.navUnselected,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
          ),
          elevation: 4,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'الرئيسية',
              backgroundColor: AppColors.surface,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_rounded),
              label: 'المباني',
              backgroundColor: AppColors.surface,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'العقود',
              backgroundColor: AppColors.surface,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined),
              label: 'الدفعات',
              backgroundColor: AppColors.surface,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'المستأجرون',
              backgroundColor: AppColors.surface,
            ),
          ],
        ),
      ),
    );
  }
}

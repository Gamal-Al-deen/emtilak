import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../views/dashboard/dashboard_page.dart';
import '../../views/properties/buildings_page.dart';
import '../../views/contracts/contracts_page.dart';
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
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.primary),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
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
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.navUnselected,
          selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_rounded),
              label: 'المباني',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'العقود',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined),
              label: 'الدفعات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'المستأجرون',
            ),
          ],
        ),
      ),
    );
  }
}

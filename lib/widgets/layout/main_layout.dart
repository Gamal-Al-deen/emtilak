import 'package:flutter/material.dart';
import '../../core/colors.dart';
import '../../utils/responsive.dart';
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

  final List<IconData> _icons = const [
    Icons.home_filled,
    Icons.apartment_rounded,
    Icons.assignment_outlined,
    Icons.receipt_outlined,
    Icons.group_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    // If wide screen (Tablet or Desktop >= 600px), show Wide Dashboard Layout with Sidebar
    if (Responsive.isWide(context)) {
      return _buildWideScreenLayout(context);
    }

    // Standard Mobile Layout (< 600px) - Unchanged for 100% mobile fidelity
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

  /// Modern responsive wide-screen layout with sidebar (No logo in nav bar)
  Widget _buildWideScreenLayout(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context) || Responsive.isLargeDesktop(context);
    final sidebarWidth = isDesktop ? 260.0 : 220.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            // Responsive Navigation Sidebar
            SizedBox(
              width: sidebarWidth,
              child: _buildSidebar(context),
            ),

            // Vertical divider separating sidebar and content
            Container(
              width: 1,
              color: AppColors.border.withValues(alpha: 0.6),
            ),

            // Main Content Area with Header
            Expanded(
              child: Column(
                children: [
                  // Wide Screen Header
                  _buildWideHeader(context),

                  // Active Page Content
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sidebar for wide screens (Tablet & Desktop) - Clean navigation without logo
  Widget _buildSidebar(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // User profile card header in sidebar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 20,
                  child: Icon(Icons.person, color: AppColors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'أحمد محمد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'مدير العقارات',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Primary Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              children: [
                // Main Section Label
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'الرئيسية',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                ),

                // Primary 5 Navigation Tabs
                for (int i = 0; i < _titles.length; i++)
                  _buildNavItem(
                    icon: _icons[i],
                    title: _titles[i],
                    isSelected: _currentIndex == i,
                    onTap: () {
                      setState(() {
                        _currentIndex = i;
                      });
                    },
                  ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.divider, height: 1),
                ),

                // Drawer items integrated into sidebar on wide screens
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'الإدارة والتقارير',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                ),

                _buildSidebarActionItem(
                  icon: Icons.analytics_outlined,
                  title: 'التقارير والأرباح',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.financialReport),
                ),
                _buildSidebarActionItem(
                  icon: Icons.currency_exchange,
                  title: 'إدارة العملات',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.currencies),
                ),
                _buildSidebarActionItem(
                  icon: Icons.build_outlined,
                  title: 'مصاريف الصيانة',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.addMaintenance),
                ),
                _buildSidebarActionItem(
                  icon: Icons.settings_outlined,
                  title: 'الإعدادات',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            ),
          ),

          // Bottom Logout Option
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
              ),
            ),
            child: _buildSidebarActionItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
              color: AppColors.error,
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Sidebar tab item button
  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isSelected
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  /// Sidebar secondary action item
  Widget _buildSidebarActionItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    final itemColor = color ?? AppColors.textPrimary;
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: color ?? AppColors.primary, size: 20),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: itemColor,
        ),
      ),
      onTap: onTap,
    );
  }

  /// Wide Screen Header
  Widget _buildWideHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Current Page Title with Breadcrumb feel
          Text(
            _titles[_currentIndex],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Cairo',
            ),
          ),

          // Header Actions (Notifications, Quick shortcuts)
          Row(
            children: [
              IconButton(
                tooltip: 'الإشعارات',
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_none_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.notifications);
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addPayment);
                },
                icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                label: const Text(
                  'دفعة جديدة',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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

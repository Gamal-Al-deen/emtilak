import 'package:flutter/material.dart';
import '../../../core/colors.dart';
import 'dashboard_welcome_card_wide.dart';
import 'dashboard_welcome_card_mobile.dart';

class DashboardWelcomeCard extends StatelessWidget {
  final double totalIncome;
  final bool isWide;

  const DashboardWelcomeCard({
    super.key,
    required this.totalIncome,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
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
          ? DashboardWelcomeCardWide(totalIncome: totalIncome)
          : DashboardWelcomeCardMobile(totalIncome: totalIncome),
    );
  }
}

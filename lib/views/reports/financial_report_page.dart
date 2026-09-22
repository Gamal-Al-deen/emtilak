import 'package:flutter/material.dart';

import 'widgets/financialreportcontent.dart';

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  @override
  Widget build(BuildContext context) {
    return const FinancialReportContent();
  }
}

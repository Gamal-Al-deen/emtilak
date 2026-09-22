import 'package:flutter/material.dart';

import 'widgets/currenciescontent.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({super.key});

  @override
  State<CurrenciesPage> createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  @override
  Widget build(BuildContext context) {
    return const CurrenciesContent();
  }
}

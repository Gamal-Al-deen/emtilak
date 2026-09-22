import 'package:flutter/material.dart';

import 'widgets/unitdetailscontent.dart';

class UnitDetailsPage extends StatefulWidget {
  const UnitDetailsPage({super.key});

  @override
  State<UnitDetailsPage> createState() => _UnitDetailsPageState();
}

class _UnitDetailsPageState extends State<UnitDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return const UnitDetailsContent();
  }
}

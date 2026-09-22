import 'package:flutter/material.dart';

import 'widgets/unitsgridcontent.dart';

class UnitsGridPage extends StatefulWidget {
  const UnitsGridPage({super.key});

  @override
  State<UnitsGridPage> createState() => _UnitsGridPageState();
}

class _UnitsGridPageState extends State<UnitsGridPage> {
  @override
  Widget build(BuildContext context) {
    return const UnitsGridContent();
  }
}

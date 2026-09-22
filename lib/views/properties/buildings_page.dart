import 'package:flutter/material.dart';

import 'widgets/buildingscontent.dart';

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  @override
  Widget build(BuildContext context) {
    return const BuildingsContent();
  }
}

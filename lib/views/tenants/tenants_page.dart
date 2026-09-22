import 'package:flutter/material.dart';

import 'widgets/tenantscontent.dart';

class TenantsPage extends StatefulWidget {
  const TenantsPage({super.key});

  @override
  State<TenantsPage> createState() => _TenantsPageState();
}

class _TenantsPageState extends State<TenantsPage> {
  @override
  Widget build(BuildContext context) {
    return const TenantsContent();
  }
}

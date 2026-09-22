import 'package:flutter/material.dart';

import 'widgets/addmaintenancecontent.dart';

class AddMaintenancePage extends StatefulWidget {
  const AddMaintenancePage({super.key});

  @override
  State<AddMaintenancePage> createState() => _AddMaintenancePageState();
}

class _AddMaintenancePageState extends State<AddMaintenancePage> {
  @override
  Widget build(BuildContext context) {
    return const AddMaintenanceContent();
  }
}

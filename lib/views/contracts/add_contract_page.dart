import 'package:flutter/material.dart';

import 'widgets/addcontractcontent.dart';

class AddContractPage extends StatefulWidget {
  const AddContractPage({super.key});

  @override
  State<AddContractPage> createState() => _AddContractPageState();
}

class _AddContractPageState extends State<AddContractPage> {
  @override
  Widget build(BuildContext context) {
    return const AddContractContent();
  }
}

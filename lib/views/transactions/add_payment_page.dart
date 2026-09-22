import 'package:flutter/material.dart';

import 'widgets/addpaymentcontent.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return const AddPaymentContent();
  }
}

import 'package:flutter/material.dart';

import '../../view/screen/cart/oredresummery_container_widget.dart';

class OrderSummeryScreen extends StatelessWidget {
  const OrderSummeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Order Summery"),
        backgroundColor: Colors.white,
      ),
      body: const Column(
        children: [
          OrderSummaryWidget(),
        ],
      ),
    );
  }
}

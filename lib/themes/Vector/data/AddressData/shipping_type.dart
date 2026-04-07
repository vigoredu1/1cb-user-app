import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/core_widget/common_button.dart';

import '../../utility/app_theme.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  String selectedOption = "standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
      appBar: AppBar(
        backgroundColor:
            AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
        title: const Text(
          ' Choose Shipping',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  color: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor,
                            ),
                            child: const Icon(Icons.local_shipping,
                                color: Colors.blue)),
                        const SizedBox(width: 10),
                        // Text
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Economy",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Estimated Arrival, Dec 20-23",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        // Price
                        const Text(
                          "₹50",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        // Radio Button
                        Radio<String>(
                          value: "standard",
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor,
                            ),
                            child: const Icon(Icons.local_shipping,
                                color: Colors.blue)),
                        const SizedBox(width: 10),
                        // Text
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Economy",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Estimated Arrival, Dec 20-23",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        // Price
                        const Text(
                          "₹100",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        // Radio Button
                        Radio<String>(
                          value: "express",
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
                width: double.infinity,
                child: CommonButton(
                  onTap: () {},
                  buttonText: 'Apply',
                ))
          ],
        ),
      ),
    );
  }
}

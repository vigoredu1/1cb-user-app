import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

import '../../utility/app_theme.dart';
import '../../utility/svg_assets.dart';
import '../../widget/common_appbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod = "card_0"; // default Mastercard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const CommonAppBar(
                    appName: "Payment Method",
                    isIcon: true,
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  // --- Card Section ---
                  Text("Your Card",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  _buildCardTile(
                    title: "Mastercard **** **** 1202",
                    subtitle: "Expires on 01/25",
                    icon: SvgAssets.iconMasterCard,
                    value: "card_0",
                    selectedValue: selectedPaymentMethod,
                    onTap: (val) {
                      setState(() => selectedPaymentMethod = val);
                    },
                  ),

                  _buildCardTile(
                    title: "Visa **** **** 1211",
                    subtitle: "Expires on 02/24",
                    icon: SvgAssets.iconVisaCard,
                    value: "card_1",
                    selectedValue: selectedPaymentMethod,
                    onTap: (val) {
                      setState(() => selectedPaymentMethod = val);
                    },
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text("+ Add New Card",
                          style: TextStyle(
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .primaryColor)),
                    ),
                  ),

                  Divider(
                    height: 30,
                    color: AppTheme.fromType(AppTheme.defaultTheme).shadowColor,
                  ),

                  // --- Wallet Section ---
                  Text("Wallet",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: AppTheme.fromType(AppTheme.defaultTheme)
                                .primaryColor
                                .withOpacity(0.07)),
                        color:
                            AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .shadowColorThree,
                              spreadRadius: 2,
                              blurRadius: 8)
                        ]),
                    child: Column(
                      children: [
                        _buildWalletTile(
                          title: "Pay Pal",
                          icon: SvgAssets.iconPaypal,
                          value: "wallet_0",
                          selectedValue: selectedPaymentMethod,
                          onTap: (val) {
                            setState(() => selectedPaymentMethod = val);
                          },
                        ),
                        _buildWalletTile(
                          title: "Apple Pay",
                          icon: SvgAssets.iconApplePay,
                          value: "wallet_1",
                          selectedValue: selectedPaymentMethod,
                          onTap: (val) {
                            setState(() => selectedPaymentMethod = val);
                          },
                        ),
                        _buildWalletTile(
                          title: "Google Pay",
                          icon: SvgAssets.iconGpay,
                          value: "wallet_2",
                          selectedValue: selectedPaymentMethod,
                          onTap: (val) {
                            setState(() => selectedPaymentMethod = val);
                          },
                        ),
                        _buildWalletTile(
                          title: "Cash on Delivery",
                          icon: SvgAssets.iconCashOnDelivery,
                          value: "wallet_3",
                          selectedValue: selectedPaymentMethod,
                          onTap: (val) {
                            setState(() => selectedPaymentMethod = val);
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Bottom Bar ---
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total price",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      Text("₹25305.0",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Selected Payment: $selectedPaymentMethod");
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      backgroundColor:
                          AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child:
                        Text("Pay Now", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- Card Tile ---
  Widget _buildCardTile({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
    required String? selectedValue,
    required Function(String) onTap,
  }) {
    return InkWell(
      onTap: () => onTap(value),
      child: Container(
        height: 67,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 1,
                color: AppTheme.fromType(AppTheme.defaultTheme)
                    .primaryColor
                    .withOpacity(0.07)),
            color: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
            boxShadow: [
              BoxShadow(
                  color:
                      AppTheme.fromType(AppTheme.defaultTheme).shadowColorThree,
                  spreadRadius: 2,
                  blurRadius: 8)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 15),
                  child: SvgPicture.asset(icon, fit: BoxFit.scaleDown),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87)),
                      Text(subtitle,
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),

            // ✅ CommonRadio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildRadio(value == selectedValue),
            ),
          ],
        ),
      ),
    );
  }

  // --- Wallet Tile ---
  Widget _buildWalletTile({
    required String title,
    required String icon,
    required String value,
    required String? selectedValue,
    required Function(String) onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: () => onTap(value),
      child: Column(
        children: [
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(icon, fit: BoxFit.scaleDown)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black87)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildRadio(value == selectedValue),
                )
              ],
            ),
          ),
          if (showDivider)
            DottedLine(
              dashLength: 5,
              dashGapLength: 2,
              dashColor: AppTheme.fromType(AppTheme.defaultTheme).shadowColor,
            ),
        ],
      ),
    );
  }

  // --- CommonRadio Widget ---
  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: isSelected
                ? AppTheme.fromType(AppTheme.defaultTheme).primaryColor
                : AppTheme.fromType(AppTheme.defaultTheme).lightText),
        color: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
      ),
      child: isSelected
          ? Icon(Icons.circle,
              color: AppTheme.fromType(AppTheme.defaultTheme).primaryColor,
              size: 13)
          : null,
    );
  }
}

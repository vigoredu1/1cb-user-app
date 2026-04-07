import 'package:flutter/material.dart';

import '../../../utility/app_theme.dart';
import '../../../utility/images.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy coupon data list
    final List<Map<String, String>> coupons = [
      {
        "title": "Gpay",
        "desc": "Buy 1 phone and get 10% off on second phone.",
        "code": "#A1OPEN000542",
        "discount": "60%"
      },
      {
        "title": "Paytm",
        "desc": "Flat ₹200 cashback on recharge above ₹500.",
        "code": "#A1OPEN000538",
        "discount": "30%"
      },
      {
        "title": "AmazonPay",
        "desc": "20% off on your first order.",
        "code": "#A1OPEN000540",
        "discount": "20%"
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Coupons",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        backgroundColor: AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
      ),
      body: Column(
        children: [
          // ListView for coupons
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                final coupon = coupons[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Stack(
                    children: [
                      // Background Coupon Image
                      Image.asset(
                        Images.coopna,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),

                      // Discount text (vertical left)
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: RichText(
                            text: TextSpan(
                              text: coupon["discount"]!,
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: ' OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Text and content on top of image
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 75),
                                child: Text(
                                  coupon["title"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 75),
                                child: Text(
                                  coupon["desc"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 75,
                                endIndent: 12,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 75),
                                    child: Text(
                                      coupon["code"]!,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: const Text(
                                      "Apply",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

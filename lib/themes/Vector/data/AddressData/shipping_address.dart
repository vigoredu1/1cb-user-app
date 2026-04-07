import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/data/AddressData/add_new_address.dart';
import 'package:svg_flutter/svg.dart';

import '../../utility/app_theme.dart';
import '../../utility/svg_assets.dart';
import '../../widget/common_appbar.dart';

class ShippingDetailsScreen extends StatefulWidget {
  const ShippingDetailsScreen({super.key});

  @override
  _ShippingDetailsScreenState createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  String selectedAddress = "Home";

  List<Map<String, String>> addresses = [
    {
      "type": "Home",
      "address": "3501 Maloy Court, East Emhurst, New York City, NY 11369",
      "phone": "78596 0000"
    },
    {
      "type": "Office",
      "address": "8502-8503 Preston Rd. Inglewood Street, Maine 983800",
      "phone": "12100 0023"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.fromType(
          AppTheme.defaultTheme)
          .backGroundColorMain,
      // appBar: AppBar(
      //   title: Text("Shipping Details", style: TextStyle(color: Colors.black)),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(
              appName: "Shipping Details",
              isIcon: true,
            ),
            SizedBox(height: 10,),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return _buildAddressBox(
                    type: address["type"]!,
                    address: address["address"]!,
                    phone: address["phone"]!,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewAddressScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.fromType(AppTheme.defaultTheme).searchBackground,
                    borderRadius: BorderRadius.circular(8),
                    // border: Border.all(
                    //   color: Colors.grey.shade400,
                    //   width: 1,
                    // ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "+ Add New Address",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () {
                  // Handle Apply
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.fromType(
                      AppTheme.defaultTheme)
                      .primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                    child: Text("Apply",
                        style: TextStyle(fontSize: 16, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressBox({
    required String type,
    required String address,
    required String phone,
  }) {
    bool isSelected = selectedAddress == type;

    return Container(decoration:
      BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   width: 1,
          //   color: selectedAddress == index
          //       ? isTheme(context)
          //       ? AppTheme.fromType(
          //       AppTheme.defaultTheme)
          //       .lightText
          //       : AppTheme.fromType(
          //       AppTheme.defaultTheme)
          //       .primaryColor
          //       : isTheme(context)
          //       ? appColor(context).appTheme.primaryColor
          //       : appColor(context).appTheme.primaryColor.withOpacity(
          //       0.07) /*appColor(context).appTheme.colorContainer*/,
          // ),
          border: Border.all(
            width: 1,
            color: isSelected
                ? AppTheme.fromType(AppTheme.defaultTheme).primaryColor
                : Colors.grey.shade300,
          ),
          color: AppTheme.fromType(
              AppTheme.defaultTheme)
              .colorContainer,
          boxShadow: [
            BoxShadow(
                color: AppTheme.fromType(
                    AppTheme.defaultTheme)
                    .lightText,
                spreadRadius: 2,
                blurRadius: 4)
          ]),
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 16),
      // padding: const EdgeInsets.all(12),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(
      //     color: Colors.grey.shade300,
      //     width: 1,
      //   ),
      // ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: type,
            groupValue: selectedAddress,
            activeColor: Colors.black,
            onChanged: (val) {
              setState(() {
                selectedAddress = val!;
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  "Phone no. : $phone",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon:  SvgPicture.asset(
                  SvgAssets.iconShippingEdit,
                  fit: BoxFit.scaleDown,
                ),
                onPressed: () {
                  // Edit Address
                },
              ),
              IconButton(
                icon:  SvgPicture.asset(
              SvgAssets.iconTrash,
    fit: BoxFit.scaleDown,
    ),
                onPressed: () {
                  setState(() {
                    addresses.removeWhere((a) => a["type"] == type);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }

}

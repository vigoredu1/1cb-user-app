// import 'package:flutter/material.dart';
// import 'package:one_click_builder/view/screen/home/home_page.dart';
// import 'package:provider/provider.dart';
// import '../../../data/model/home/best_selling_product_model.dart';
// import '../../../data/model/home/checkout_model.dart';
// import '../../../service/checkout_api.dart';
// import '../../../utility/local_storage.dart';
// import 'checkout_controller.dart';
// import 'dropdown_c_s_c.dart'; // import the controller
//
// class CheckoutScreen extends StatefulWidget {
//   final CheckoutController controller;
//   final Product product;
//
//   const CheckoutScreen(
//       {super.key, required this.controller, required this.product});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   String _selectedPaymentMethod = "COD";
//
//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(title: const Text("Checkout")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // _buildSectionTitle("Information"),
//             // const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                     child: _buildField(
//                         "First Name *", widget.controller.firstNameController)),
//                 const SizedBox(width: 8),
//                 Expanded(
//                     child: _buildField(
//                         "Last Name *", widget.controller.lastNameController)),
//               ],
//             ),
//             const SizedBox(height: 8),
//             _buildField("Phone Number *", widget.controller.phoneController),
//             const SizedBox(height: 12),
//             IndiaStateCityDropdown(
//               countryController: widget.controller.countryController,
//               stateController: widget.controller.stateController,
//               cityController: widget.controller.cityController,
//             ),
//             const SizedBox(height: 12),
//             _buildField("Street", widget.controller.streetController),
//             const SizedBox(height: 8),
//             _buildField(
//                 "Postal Code *", widget.controller.postalCodeController),
//             const SizedBox(height: 12),
//             _buildField("Write note...", widget.controller.noteController,
//                 maxLines: 3),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Select Payment Method",
//               ),
//               value: "COD",
//               items: const [
//                 DropdownMenuItem(value: "COD", child: Text("Cash on Delivery")),
//                 DropdownMenuItem(value: "UPI", child: Text("UPI")),
//                 DropdownMenuItem(value: "Card", child: Text("Card")),
//               ],
//               onChanged: (value) {
//                 debugPrint("Selected Payment Method: $value");
//                 setState(() {
//                   _selectedPaymentMethod = value!;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildSectionTitle("Your Order"),
//             ListTile(
//               leading: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: product.images!.isNotEmpty
//                     ? const Placeholder(fallbackHeight: 250)
//                 // Image.network(
//                 //         product.images!.first,
//                 //         height: 300,
//                 //         width: 80,
//                 //         fit: BoxFit.cover,
//                 //       )
//                     : const Placeholder(fallbackHeight: 250),
//               ),
//               title: Text(
//                 " ${product.title}",
//                 style:
//                     const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.start,
//               ),
//               subtitle: Text(
//                 " ₹${product.price}",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Divider(),
//             _buildSummaryRow("Tax & Charges", "₹ 0"),
//             _buildSummaryRow("Shipping", "Free"),
//             _buildSummaryRow("Discount", "₹ 0"),
//             const Divider(),
//             _buildSummaryRow("Total", "₹${product.price}", isTotal: true),
//             const SizedBox(height: 20),
//             InkWell(
//               onTap: () async {
//                 debugPrint("PROCEED tapped");
//                 final provider =
//                     Provider.of<CheckoutProvider>(context, listen: false);
//                 final product = widget.product;
//                 final controller = widget.controller;
//                 final vendorId = await StorageHelper.getVendorId();
//
//                 final orderModel = OrderCreateModel(
//                   order: Order(
//                     vendorId: vendorId, // Or get from localStorage
//                     paymentMethod: _selectedPaymentMethod,
//                     shippingMethod: "Express",
//                     status: "Pending",
//                     discount: 0,
//                     ship: 0,
//                     orderType: "website",
//                   ),
//                   orderItems: [
//                     OrderItem(
//                       productId: product.id ?? "",
//                       quantity: 1,
//                       price: product.price?.toInt() ?? 0,
//                     ),
//                   ],
//                   billingAddress: IngAddress(
//                     name:
//                         "${controller.firstNameController.text} ${controller.lastNameController.text}",
//                     mobileNumber: controller.phoneController.text,
//                     country: controller.countryController.text,
//                     state: controller.stateController.text,
//                     city: controller.cityController.text,
//                     zipCode: controller.postalCodeController.text,
//                     streetAddress: controller.streetController.text,
//                   ),
//                   shippingAddress: IngAddress(
//                     name:
//                         "${controller.firstNameController.text} ${controller.lastNameController.text}",
//                     mobileNumber: controller.phoneController.text,
//                     country: controller.countryController.text,
//                     state: controller.stateController.text,
//                     city: controller.cityController.text,
//                     zipCode: controller.postalCodeController.text,
//                     streetAddress: controller.streetController.text,
//                   ),
//                 );
//
//                 await provider.checkoutCreateOrder(orderModel);
//
//                 // if (provider.checkoutResponse?.data?.orderId != null) {
//                 //   ScaffoldMessenger.of(context).showSnackBar(
//                 //     SnackBar(
//                 //       content: Text(
//                 //           "✅ Order Created: ${provider.checkoutResponse!.data!.orderId}"),
//                 //       backgroundColor: Colors.green,
//                 //     ),
//                 //   );
//                 // }
//                 if (provider.checkoutResponse?.data?.orderId != null) {
//                   final orderId = provider.checkoutResponse!.data!.orderId!;
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text("✅ Order Placed!"),
//                         content: Text(
//                           "Your order was created successfully : $orderId",
//                           style: const TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w400),
//                         ),
//                         actions: [
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).pop(); // Close dialog
//                               // Navigate to Home Screen
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const HomePage()),
//                               );
//                             },
//                             child: Container(
//                               height: 40,
//                               alignment: Alignment.center,
//                               decoration: const BoxDecoration(
//                                 color: Colors.black,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(12)),
//                               ),
//                               child: const Text(
//                                 "Go To Home",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                           "❌ Failed: ${provider.errorMessage ?? "Unknown error"}"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 height: 50,
//                 alignment: Alignment.center,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//                 child: const Text(
//                   "PROCEED",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildField(String hint, TextEditingController controller,
//       {int maxLines = 1}) {
//     return TextField(
//       controller: controller,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label,
//               style: isTotal
//                   ? const TextStyle(fontWeight: FontWeight.bold)
//                   : null),
//           Text(value,
//               style: isTotal
//                   ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
//                   : null),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//     );
//   }
// }
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:svg_flutter/svg.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../core_widget/common_button.dart';
import '../../../data/AddressData/shipping_address.dart';
import '../../../data/AddressData/shipping_type.dart';
import '../../../data/payment/payment_screen.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/svg_assets.dart';
import '../cart/cart_screen.dart';
import '../cart/coupan_screen.dart';


class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final controller = Provider.of<CartController>(context, listen: false);
    // final tokken = StorageHelper.getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.cartData == null && !controller.isLoading) {
        controller.fetchCart();
      }
    });
    return _buildCartContent(context);
  }

  Widget _buildCartContent(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              // onTap: AppDrawer(),
                child: Container(
                    height: 40,
                    width: 40,
                    //decoration
                    decoration: BoxDecoration(
                        color: AppTheme.fromType(AppTheme.defaultTheme)
                            .colorContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.fromType(AppTheme.defaultTheme)
                              .primaryColor
                              .withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: AppTheme.fromType(AppTheme.defaultTheme)
                                  .shadowColorThree,
                              spreadRadius: 2,
                              blurRadius: 8)
                        ]),
                    //svg icon
                    child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.iconWishlist,
                          fit: BoxFit.scaleDown,
                          height: 20,
                          width: 20,
                        )))),
          )
        ],
      ),
      body: Consumer<CartController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return  Center(child:  Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 20,
      color: Colors.white,
    ),
  ),);
          }

          if (controller.error != null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 100,
                  ),
                  Text('Somethings Wants wrong'),
                ],
              ),
            );
          }

          final cartData = controller.cartData;
          if (cartData == null || cartData.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Shipping Address",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShippingDetailsScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.fromType(AppTheme.defaultTheme)
                            .backGroundColorMain,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                    AppTheme.fromType(AppTheme.defaultTheme)
                                        .searchBackground,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:
                                    AppTheme.fromType(AppTheme.defaultTheme)
                                        .primaryColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Home",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "SRS tower sector 31..",
                                  style: TextStyle(
                                    color:
                                    AppTheme.fromType(AppTheme.defaultTheme)
                                        .lightText,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SvgPicture.asset(
                              SvgAssets.iconShippingEdit,
                              fit: BoxFit.scaleDown,
                              height: 40,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey, // divider color
                  thickness: 0.5, // divider ki motai (height)
                  indent: 15, // left se gap
                  endIndent: 15, // right se gap
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartData.items.length,
                  itemBuilder: (context, index) {
                    final item = cartData.items[index];
                    return CartItemWidget(
                      item: item,
                      onRemove: () => controller.removeItem(item.productId),
                    );
                  },
                ),
                const Divider(
                  color: Colors.grey, // divider color
                  thickness: 0.5, // divider ki motai (height)
                  indent: 10, // left se gap
                  endIndent: 10, // right se gap
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Choose Shipping",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                        AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset(
                            SvgAssets.iconFastTruck,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                AppTheme.fromType(AppTheme.defaultTheme)
                                    .primaryColor,
                                BlendMode.srcIn),
                            height: 50,
                          ),
                          const Text("Choose Shipping Type"),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShippingScreen()));
                  },
                ),
                const Divider(
                  color: Colors.grey, // divider color
                  thickness: 0.5, // divider ki motai (height)
                  indent: 12, // left se gap
                  endIndent: 12, // right se gap
                ),

                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Promo Code",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DottedBorder(
                    color: Colors.grey, // dotted border color
                    strokeWidth: 1.5, // border thickness
                    dashPattern: [6, 3], // 6 length line, 3 gap
                    borderType: BorderType.RRect, // Rounded Rectangle
                    radius: const Radius.circular(5),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.fromType(AppTheme.defaultTheme)
                            .searchBackground,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Text("#A103jdcbdNBGCuhvwgiwwgw"),
                          const Spacer(),
                          Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: InkWell(
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const CouponScreen()));
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ),


                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Order Info",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.fromType(AppTheme.defaultTheme)
                          .searchBackground,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sub Total',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  )),
                              Text(
                                "₹${cartData.cart!.totalPrice}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Shipping Charges',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  )),
                              Text(
                                "₹0.0",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Discount (10%)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  )),
                              Text(
                                "₹0.0",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey, // divider color
                          thickness: 1, // divider ki motai (height)
                          indent: 10, // left se gap
                          endIndent: 10, // right se gap
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "₹${cartData.cart!.totalPrice}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  PaymentScreen()));
                        }, buttonText: "Continue To Payment"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

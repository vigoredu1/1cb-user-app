import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Vector/widget/common_button.dart';
import 'package:provider/provider.dart';

import '../../controller/productorder_provider.dart';

class ProductOrderPage extends StatelessWidget {
  const ProductOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BuyProductProvider>(
      create: (_) => BuyProductProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Product Buy Page",
              style: TextStyle(color: Colors.black)),
        ),
        body: const ProductBuyForm(),
      ),
    );
  }
}

class ProductBuyForm extends StatefulWidget {
  const ProductBuyForm({super.key});

  @override
  _ProductBuyFormState createState() => _ProductBuyFormState();
}

class _ProductBuyFormState extends State<ProductBuyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final buyProvider = Provider.of<BuyProductProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Information" dropdown header.
            GestureDetector(
              onTap: () {
                buyProvider.toggleInfoExpansion();
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Information",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      buyProvider.isInfoExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (buyProvider.isInfoExpanded) ...[
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Horizontal, Vertical offset
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: buyProvider.nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black87,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Last Name field
                    TextFormField(
                      controller: buyProvider.lastNameController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black87,
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your last name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Email field
                    TextFormField(
                      controller: buyProvider.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Phone Number field
                    TextFormField(
                      controller: buyProvider.phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: Colors.black87,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your phone number";
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return "Please enter a valid 10-digit phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            ],
            // Always visible fields.

            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Horizontal, Vertical offset
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Country picker field.
                  TextFormField(
                    controller: buyProvider.countryController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Select Country",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87)),
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                    // onTap: () {
                    //   showCountryPicker(
                    //     context: context,
                    //     showPhoneCode: false,
                    //     onSelect: (Country country) {
                    //       buyProvider.countryController.text = country.name;
                    //     },
                    //   );
                    // },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please select a country";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // City field.
                  TextFormField(
                    controller: buyProvider.cityController,
                    decoration: InputDecoration(
                      labelText: "Select City",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.location_city_rounded,
                        color: Colors.black87,
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a city";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Pincode field.
                  TextFormField(
                    controller: buyProvider.pincodeController,
                    decoration: InputDecoration(
                      labelText: "Select Pincode",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.password,
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a pincode";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Street Address.
                  TextFormField(
                    controller: buyProvider.streetAddressController,
                    decoration: InputDecoration(
                      labelText: "Street Address",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.pin_drop,
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your street address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Postal Code.
                  TextFormField(
                    controller: buyProvider.postalCodeController,
                    decoration: InputDecoration(
                      labelText: "Postal Code",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.pin,
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your postal code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Comments field (multi-line).
                  TextFormField(
                    controller: buyProvider.commentsController,
                    decoration: InputDecoration(
                      labelText: "Comments",
                      labelStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Buy button with validation.
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // If form is valid, call the provider's buyProduct function.
                    buyProvider.buyProduct();
                  } else {
                    // Otherwise, validation errors will appear below the fields.
                    print("Validation failed");
                  }
                },
                buttonText: 'Buy',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

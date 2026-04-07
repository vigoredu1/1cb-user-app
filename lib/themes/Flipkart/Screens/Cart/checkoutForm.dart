import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_click_builder/themes/Flipkart/Modules/Address/saveAddress.dart';
import 'package:one_click_builder/themes/Flipkart/Screens/profile/screens/OrdersReturnsScreen.dart';
import 'package:one_click_builder/themes/Flipkart/api/cart/create_order_service.dart';
import 'package:one_click_builder/themes/Flipkart/api/payment/paymentService.dart';
import 'package:one_click_builder/themes/Flipkart/api/payment/paymenttype.dart';
import 'package:one_click_builder/themes/Flipkart/api/payment/verifyPayment.dart';
import 'package:one_click_builder/payment/phonepe_intent_launcher.dart';

import 'dart:convert';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Amazon/utility/plugin_list.dart';

class CheckoutForm extends StatefulWidget {
  final dynamic cartCtrl;
  final dynamic vendorCtrl;

  const CheckoutForm({
    super.key,
    required this.cartCtrl,
    required this.vendorCtrl,
  });

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  List<SavedAddress> savedAddresses = [];
  SavedAddress? selectedAddress;
  bool showForm = false;
  Razorpay? _razorpay;
  bool isGatewayLoading = false;
  bool isVerifyingPayment = false;
  String? currentOrderId; // add at top of class
  bool _awaitingExternalPaymentReturn = false;

  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final addressLine1Ctrl = TextEditingController();
  final addressLine2Ctrl = TextEditingController();
  final labelCtrl = TextEditingController();
  String selectedLabel = "Home";

  String? state, city;
  String? country = "India"; // default country
  String? paymentMethod;
  bool stateError = false;
  bool cityError = false;

  bool isLoading = false;
  List<String> deliveryTypes = [];
  bool isPaymentLoading = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _razorpay?.clear();
    nameCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    streetCtrl.dispose();
    zipCtrl.dispose();
    super.dispose();
  }

  bool _validateMobile() {
    final value = mobileCtrl.text.trim();

    if (value.isEmpty) {
      Get.snackbar(
        "Invalid Mobile",
        "Mobile number is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      Get.snackbar(
        "Invalid Mobile",
        "Enter valid 10-digit Indian mobile number",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return false;
    }

    return true;
  }

  String _normalizeMobileForOrder(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 12 && digits.startsWith('91')) {
      return digits;
    }
    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  bool _isValidOrderMobile(String value) {
    return RegExp(r'^\d{10,15}$').hasMatch(value);
  }

  String? _mapPaymentMethodForApi(String? selectedMethod) {
    final normalized = selectedMethod?.trim().toUpperCase();
    switch (normalized) {
      case 'COD':
      case 'CASH ON DELIVERY':
      case 'CASH_ON_DELIVERY':
        return 'COD';
      case 'PREPAID':
      case 'UPI':
      case 'ONLINE':
      case 'RAZORPAY':
      case 'PHONEPE':
        return 'UPI';
      default:
        return null;
    }
  }

  dynamic _requireCartForCheckout() {
    final cart = widget.cartCtrl.cart.value;
    if (cart == null || cart.items.isEmpty) {
      Get.snackbar(
        "Cart Empty",
        "Add at least one item before placing the order.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
    return cart;
  }

  Future<Map<String, dynamic>?> _getGatewayForDigitalPayment() async {
    final gateway = await PaymentGatewayService.getActiveGateway(
      widget.vendorCtrl.vendorId.value,
    );

    if (gateway == null) {
      Get.snackbar("Payment Error", "No active payment gateway found");
      return null;
    }

    final title = gateway["title"]?.toString().toUpperCase();
    if (title != 'RAZORPAY' && title != 'PHONEPE') {
      Get.snackbar("Payment Error", "Unsupported payment gateway");
      return null;
    }

    return gateway;
  }

  double? _extractPayableAmount(Map<String, dynamic> orderResponse) {
    const keys = ['amount', 'payableAmount', 'totalAmount', 'grandTotal'];

    for (final key in keys) {
      final parsed = _tryParseAmount(orderResponse[key]);
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }

    for (final nestedKey in ['data', 'payment', 'order']) {
      final nested = orderResponse[nestedKey];
      if (nested is! Map<String, dynamic>) {
        continue;
      }
      for (final key in keys) {
        final parsed = _tryParseAmount(nested[key]);
        if (parsed != null && parsed > 0) {
          return parsed;
        }
      }
    }

    final cart = widget.cartCtrl.cart.value;
    return cart?.totalPrice;
  }

  double? _tryParseAmount(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    loadAddresses().then((value) {
      setState(() {
        savedAddresses = value;
        showForm = value.isEmpty;

        if (value.isNotEmpty) {
          selectedAddress = value.first;
        }
      });
    });

    _loadPaymentMethods();
  }

  void _openRazorpay(String apiKey, String sessionId, double amount) {
    if (amount <= 0) {
      Get.snackbar("Payment Error", "Invalid payable amount for payment");
      return;
    }

    var options = {
      'key': apiKey,
      'amount': (amount * 100).toInt(),
      'name': 'Your Store',
      'description': 'Order Payment',
      'order_id': sessionId,
      'prefill': {
        'contact': mobileCtrl.text,
        'email': emailCtrl.text,
      },
      'theme': {'color': '#F28BA8'}
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print("Razorpay open error: $e");
      Get.snackbar("Payment Error", "Unable to open payment gateway");
    }
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final vendorId = widget.vendorCtrl.vendorId.value;

      final types = await PaymentService().getDeliveryTypes(vendorId);

      setState(() {
        // ✅ If empty → force COD
        if (types.isEmpty) {
          deliveryTypes = ["COD"];
          paymentMethod = "COD";
        } else {
          deliveryTypes = types.map((e) => e.toUpperCase()).toList();

          // ✅ If COD exists → set default COD
          if (deliveryTypes.contains("COD")) {
            paymentMethod = "COD";
          } else {
            paymentMethod = deliveryTypes.first;
          }
        }

        isPaymentLoading = false;
      });
    } catch (e) {
      // ✅ If API error → force COD
      setState(() {
        deliveryTypes = ["COD"];
        paymentMethod = "COD";
        isPaymentLoading = false;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _awaitingExternalPaymentReturn &&
        currentOrderId != null &&
        mounted) {
      _verifyPendingExternalPayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.99,
      maxChildSize: 0.99,
      minChildSize: 0.80,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // 👈 moves UI up with keyboard
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Form(
                key: _formKey,
                child: ListView(
                  controller: controller,
                  children: [
                    if (savedAddresses.isNotEmpty && !showForm) ...[
                      const Text(
                        "Select Delivery Address",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ...savedAddresses.map((addr) {
                        final isSelected = selectedAddress == addr;

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    selectedAddress = addr;
                                  });

                                  _showOrderConfirmation(addr);
                                },
                          child: Card(
                            color:
                                isSelected ? Colors.blue.shade50 : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(addr.name),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _showDeleteConfirmation(addr);
                                        },
                                      )
                                    ],
                                  ),
                                  Text(addr.mobile),
                                  Text(
                                      "${addr.street}, ${addr.city}, ${addr.state}"),
                                  Text(addr.zip),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showForm = true;
                          });
                        },
                        child: const Text("+ Add New Address"),
                      ),
                    ],
                    if (showForm) ...[
                      Center(
                        child: Container(
                          height: 5,
                          width: 60,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),

                      const Text(
                        "Your Addresses",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),

                      // ------------------ Country -------------------
                      // ------------------ COUNTRY (TOP) ------------------
                      // ------------------ COUNTRY DROPDOWN (ONLY INDIA) ------------------

                      const SizedBox(height: 15),
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "📍 Delivery Address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Address Type",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  children: ["Home", "Office", "Shop", "Other"]
                                      .map((type) {
                                    final isSelected = selectedLabel == type;

                                    return ChoiceChip(
                                      label: Text(type),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        setState(() {
                                          selectedLabel = type;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            _input(
                              nameCtrl,
                              "Full name",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Full name is required";
                                }

                                final value = v.trim();

                                if (value.length < 3) {
                                  return "Enter valid full name";
                                }

                                // Only letters and spaces
                                if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
                                  return "Name should contain only letters";
                                }

                                // Must contain at least 2 words (first & last name)
                                if (value.split(" ").length < 2) {
                                  return "Enter first and last name";
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            _input(
                              emailCtrl,
                              "Email address",
                              keyboard: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Email is required";
                                }

                                final value = v.trim();

                                if (!RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return "Enter valid email address";
                                }

                                return null;
                              },
                            ),

                            IntlPhoneField(
                              controller: mobileCtrl, // ✅ REQUIRED
                              initialCountryCode: 'IN',
                              disableLengthCheck: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: 'Mobile number',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (phone) {
                                final value = phone?.number.trim() ?? "";

                                if (value.isEmpty) {
                                  return "Mobile number is required";
                                }

                                // Must be valid Indian 10-digit number starting with 6-9
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                                  return "Enter valid 10-digit Indian mobile number";
                                }

                                // 🚫 Block repeated digits like 9999999999
                                if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
                                  return "Invalid mobile number";
                                }

                                return null;
                              },

                              onChanged: (phone) {
                                mobileCtrl.text = phone.number;
                              },
                            ),
                            const SizedBox(height: 10),
                            //    _input(streetCtrl, "House / Flat / Building"),
                            _input(
                              addressLine1Ctrl,
                              "Flat, House No., Building, Company, Apartment",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Address is required";
                                }

                                final value = v.trim();

                                if (value.length < 8) {
                                  return "Enter complete address";
                                }

                                // Must contain at least one digit (house number)
                                if (!RegExp(r'\d').hasMatch(value)) {
                                  return "Address must contain house/flat number";
                                }

                                // Must contain letters
                                if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                  return "Address must contain building name";
                                }

                                // Block repeated characters like aaaaaa / 111111
                                if (RegExp(r'(.)\1{3,}').hasMatch(value)) {
                                  return "Invalid address";
                                }

                                // Block obvious keyboard smash patterns
                                if (RegExp(r'(asdf|qwerty|zxcv|test|abc)',
                                        caseSensitive: false)
                                    .hasMatch(value)) {
                                  return "Invalid address";
                                }

                                return null;
                              },
                            ),

                            _input(
                              addressLine2Ctrl,
                              "Area, Street, Sector, Village",
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Area / Street is required";
                                }

                                final value = v.trim();

                                if (value.length < 5) {
                                  return "Enter valid area name";
                                }

                                // Must contain letters
                                if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                  return "Area must contain letters";
                                }

                                // Must contain space (real area names usually do)
                                if (!value.contains(" ")) {
                                  return "Enter full area name";
                                }

                                // Block repeated characters (aaaa, 1111, dddd)
                                if (RegExp(r'(.)\1{2,}').hasMatch(value)) {
                                  return "Invalid area name";
                                }

                                // Block obvious keyboard smash patterns
                                if (RegExp(r'(asdf|qwerty|zxcv|test|abc|dgdgd)',
                                        caseSensitive: false)
                                    .hasMatch(value)) {
                                  return "Invalid area name";
                                }

                                // Only allow safe characters
                                if (!RegExp(r'^[A-Za-z0-9 .,-]+$')
                                    .hasMatch(value)) {
                                  return "Invalid characters used";
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      // // ------------------ Full Name -------------------

                      const Text(
                        "🚚 Delivery available for all serviceable pincodes",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🚚 Delivery Location",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: zipCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "Pincode is required";
                                }

                                if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(v)) {
                                  return "Enter valid 6-digit Indian pincode";
                                }

                                // 🚫 Block repeated digits like 111111
                                if (RegExp(r'^(\d)\1{5}$').hasMatch(v)) {
                                  return "Invalid Indian pincode";
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "Pincode",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            CSCPickerPlus(
                              countryDropdownLabel: "Select Country",
                              stateDropdownLabel: "Select State",
                              cityDropdownLabel: "Select City",
                              onStateChanged: (value) {
                                setState(() {
                                  state = value;
                                  stateError = false;
                                  city = null; // reset city
                                });
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  city = value;
                                  cityError = false;
                                });
                              },
                            ),
                            if (stateError)
                              const Padding(
                                padding: EdgeInsets.only(top: 6, left: 12),
                                child: Text(
                                  "State is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            if (cityError)
                              const Padding(
                                padding: EdgeInsets.only(top: 4, left: 12),
                                child: Text(
                                  "City is required",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _sectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "💳 Payment Method",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 10),
                            isPaymentLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : DropdownButtonFormField<String>(
                                    value: paymentMethod,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    items: deliveryTypes.map((type) {
                                      String label;

                                      if (type.toLowerCase() == "cod") {
                                        label = "Cash on Delivery";
                                      } else if (type.toLowerCase() ==
                                          "prepaid") {
                                        label =
                                            "Digital Payment"; // ✅ CHANGED HERE
                                      } else {
                                        label = type.toUpperCase();
                                      }

                                      return DropdownMenuItem<String>(
                                        value:
                                            type.toUpperCase(), // COD / PREPAID
                                        child: Text(label),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        paymentMethod = v;
                                      });
                                    },
                                    validator: (v) => v == null
                                        ? "Select payment method"
                                        : null,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: isLoading ? null : _handlePlaceOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28BA8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "PLACE ORDER",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ],
                    if (_isProcessing)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 20),
                              Text(
                                "Processing Payment...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )),
          ),
        );
      },
    );
  }

  void _showOrderConfirmation(SavedAddress addr) {
    String? selectedPayment;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Select Payment Method"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedPayment,
                    hint: Text("Choose Payment Method"),
                    items: [
                      DropdownMenuItem(
                        value: "PREPAID",
                        child: Text("Digital Payment"),
                      ),
                      DropdownMenuItem(
                        value: "COD",
                        child: Text("Cash on Delivery"),
                      ),
                    ],
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedPayment = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedPayment == null) {
                      Get.snackbar(
                        "Error",
                        "Please select payment method",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    Navigator.pop(context);

                    setState(() => isLoading = true);

                    await _placeOrderFromCard(
                      addr,
                      selectedPayment!,
                    );

                    setState(() => isLoading = false);
                  },
                  child: Text("Proceed"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(SavedAddress addr) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Address"),
          content: const Text("Are you sure you want to delete this address?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _deleteAddress(addr);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAddress(SavedAddress addr) async {
    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getStringList("saved_addresses") ?? [];

    List<SavedAddress> addresses =
        stored.map((e) => SavedAddress.fromJson(jsonDecode(e))).toList();

    addresses.removeWhere((a) =>
        a.name == addr.name &&
        a.mobile == addr.mobile &&
        a.street == addr.street);

    final updated = addresses.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList("saved_addresses", updated);

    setState(() {
      savedAddresses = addresses;

      if (addresses.isEmpty) {
        showForm = true;
        selectedAddress = null;
      } else {
        selectedAddress = addresses.first;
      }
    });

    Get.snackbar(
      "Deleted",
      "Address removed successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _handlePlaceOrder() async {
    // 🔹 Case 1: Saved address cards exist & form not open
    if (savedAddresses.isNotEmpty && !showForm) {
      if (selectedAddress == null) {
        Get.snackbar(
          "Select Address",
          "Please select a delivery address",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      await _placeOrderFromCard(selectedAddress!, paymentMethod.toString());
    } else {
      // 🔹 Case 2: Use form data
      await _placeOrder();
    }
  }

  Future<void> _placeOrderFromCard(
    SavedAddress addr,
    String paymentMethod,
  ) async {
    setState(() {
      _isProcessing = true;
    });
    final cart = _requireCartForCheckout();
    if (cart == null) {
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    final orderItems = cart.items.map<Map<String, dynamic>>((e) {
      return {
        "product_id": e.productId,
        "productImageId": e.productImageId,
        "quantity": e.quantity,
        "price": e.sellingPrice,
      };
    }).toList();

    final normalizedMobile = _normalizeMobileForOrder(addr.mobile);
    if (!_isValidOrderMobile(normalizedMobile)) {
      Get.snackbar(
        "Invalid Address",
        "Saved address mobile number is invalid. Please edit the address.",
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    final billing = {
      "name": addr.name,
      "mobile_number": normalizedMobile,
      "country": addr.country,
      "state": addr.state,
      "city": addr.city,
      "zip_code": addr.zip,
      "street_address": addr.street,
    };

    final shipping = {
      ...billing,
      "email": addr.email,
    };

    setState(() => isLoading = true);

    final String? apiPaymentMethod = _mapPaymentMethodForApi(paymentMethod);
    if (apiPaymentMethod == null) {
      setState(() {
        isLoading = false;
        _isProcessing = false;
      });
      Get.snackbar("Payment Error", "Unsupported payment method selected");
      return;
    }
    final bool isDigital = apiPaymentMethod == "UPI";
    final gateway = isDigital ? await _getGatewayForDigitalPayment() : null;
    if (isDigital && gateway == null) {
      setState(() {
        isLoading = false;
        _isProcessing = false;
      });
      return;
    }
    final orderResponse = await CreateOrderService.createOrder(
      vendorId: widget.vendorCtrl.vendorId.value,
      paymentMethod: apiPaymentMethod,
      shippingMethod: "Express",
      orderItems: orderItems,
      billingAddress: billing,
      shippingAddress: shipping,
      showSnackbar: !isDigital, // 🔥 snackbar only for COD
    );

    setState(() => isLoading = false);

    if (orderResponse == null) {
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    // ==========================
    // ✅ COD FLOW
    // ==========================
    if (!isDigital) {
      await _afterOrderSuccess();
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    // ==========================
    // ✅ DIGITAL FLOW
    // ==========================

    final sessionId = orderResponse["paymentSessionId"]?.toString() ?? "";
    final orderId = orderResponse["orderId"]?.toString() ?? "";
    final paymentUrl = orderResponse["paymentUrl"]?.toString();
    final payableAmount = _extractPayableAmount(orderResponse);

    if (orderId.isEmpty) {
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar("Payment Error", "Order created without a valid order ID");
      return;
    }

    await _handleDigitalPayment(
      gateway!,
      sessionId,
      orderId,
      paymentUrl: paymentUrl,
      amount: payableAmount,
    );
  }

  Future<void> _afterOrderSuccess() async {
    final vendorId = widget.vendorCtrl.vendorId.value;
    await _clearCartAndNavigate(vendorId);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("✅ Payment Success: ${response.paymentId}");

    if (currentOrderId == null) {
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar("Error", "Order ID missing");
      return;
    }

    setState(() => isVerifyingPayment = true);

    final isVerified = await verifyPayment(currentOrderId!);

    setState(() => isVerifyingPayment = false);

    if (!isVerified) {
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar(
        "Verification Failed",
        "Payment received but verification failed. Please contact support.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    final vendorId = widget.vendorCtrl.vendorId.value;

    await _clearCartAndNavigate(vendorId);
    setState(() {
      _isProcessing = false;
    });

    Get.snackbar(
      "Payment Successful",
      "Order confirmed successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      _isProcessing = false;
    });
    print("❌ Payment Error: ${response.message}");

    Get.snackbar(
      "Payment Failed",
      "Payment was not completed",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("💳 External Wallet: ${response.walletName}");
  }

  Future<void> _openPhonePePayment(String url) async {
    final launched = await PhonePeIntentLauncher.launch(url);
    if (launched) {
      if (mounted) {
        setState(() {
          _awaitingExternalPaymentReturn = true;
        });
      }

      Get.snackbar(
        "Complete Payment",
        "Finish the payment in PhonePe and return to the app to verify your order.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await _openExternalPaymentUrl(url);
  }

  Future<void> _openExternalPaymentUrl(String url) async {
    final normalizedUrl = _normalizeExternalPaymentUrl(url);
    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      Get.snackbar("Payment Error", "Invalid payment URL");
      return;
    }

    var launched = false;

    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!launched && _isWebPaymentUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      if (!launched && _isWebPaymentUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
    } on PlatformException catch (error) {
      debugPrint('Payment URL launch failed: $error');
    } catch (error) {
      debugPrint('Unexpected payment URL launch error: $error');
    }

    if (!launched) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      Get.snackbar("Payment Error", "Unable to open payment gateway");
      return;
    }

    if (mounted) {
      setState(() {
        _awaitingExternalPaymentReturn = true;
      });
    }

    Get.snackbar(
      "Complete Payment",
      "Finish the payment and return to the app to verify your order.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _normalizeExternalPaymentUrl(String url) {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isEmpty) {
      return trimmedUrl;
    }

    final parsedUri = Uri.tryParse(trimmedUrl);
    if (parsedUri != null && parsedUri.hasScheme) {
      return trimmedUrl;
    }

    return 'https://$trimmedUrl';
  }

  bool _isWebPaymentUrl(Uri uri) {
    final scheme = uri.scheme.toLowerCase();
    return scheme == 'http' || scheme == 'https';
  }

  Future<void> _verifyPendingExternalPayment() async {
    if (currentOrderId == null) {
      return;
    }

    setState(() {
      _awaitingExternalPaymentReturn = false;
      isVerifyingPayment = true;
    });

    final isVerified = await verifyPayment(currentOrderId!);
    if (!mounted) {
      return;
    }

    setState(() {
      isVerifyingPayment = false;
    });

    if (!isVerified) {
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar(
        "Payment Pending",
        "Payment is not verified yet. If you completed it, try again shortly.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final vendorId = widget.vendorCtrl.vendorId.value;
    await _clearCartAndNavigate(vendorId);
    if (!mounted) {
      return;
    }
    setState(() {
      _isProcessing = false;
    });
    Get.snackbar(
      "Payment Successful",
      "Order confirmed successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _input(
    TextEditingController ctrl,
    String label, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        validator: validator ??
            (v) => v == null || v.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          filled: true,
          fillColor: Colors.grey.shade100,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_validateMobile()) return;

    final isFormValid = _formKey.currentState!.validate();

    setState(() {
      stateError = state == null || state!.isEmpty;
      cityError = city == null || city!.isEmpty;
    });

    if (!isFormValid || stateError || cityError) return;

    final cart = _requireCartForCheckout();
    if (cart == null) {
      return;
    }
    final vendorId = widget.vendorCtrl.vendorId.value;

    final streetAddress =
        "${addressLine1Ctrl.text.trim()}, ${addressLine2Ctrl.text.trim()}";

    final orderItems = cart.items.map<Map<String, dynamic>>((e) {
      return {
        "product_id": e.productId,
        "productImageId": e.productImageId,
        "quantity": e.quantity,
        "price": e.sellingPrice,
      };
    }).toList();

    final billing = {
      "name": nameCtrl.text.trim(),
      "mobile_number": _normalizeMobileForOrder(mobileCtrl.text.trim()),
      "country": country,
      "state": state,
      "city": city,
      "zip_code": zipCtrl.text.trim(),
      "street_address": streetAddress,
    };

    final shipping = {
      ...billing,
      "email": emailCtrl.text.trim(),
    };

    setState(() => isLoading = true);

    final String? apiPaymentMethod = _mapPaymentMethodForApi(paymentMethod);
    if (apiPaymentMethod == null) {
      setState(() {
        isLoading = false;
        _isProcessing = false;
      });
      Get.snackbar("Payment Error", "Unsupported payment method selected");
      return;
    }
    final bool isDigital = apiPaymentMethod == "UPI";
    final gateway = isDigital ? await _getGatewayForDigitalPayment() : null;
    if (isDigital && gateway == null) {
      setState(() {
        isLoading = false;
        _isProcessing = false;
      });
      return;
    }

    final orderResponse = await CreateOrderService.createOrder(
      vendorId: vendorId,
      paymentMethod: apiPaymentMethod,
      shippingMethod: "Express",
      orderItems: orderItems,
      billingAddress: billing,
      shippingAddress: shipping,
      showSnackbar: !isDigital,
    );

    setState(() => isLoading = false);

    if (orderResponse == null) {
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    // ✅ SAVE ADDRESS (Always after order success)
    await saveAddress(
      SavedAddress(
        label: selectedLabel,
        name: nameCtrl.text.trim(),
        mobile: mobileCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        country: country ?? "India",
        state: state ?? "",
        city: city ?? "",
        zip: zipCtrl.text.trim(),
        street: streetAddress,
      ),
    );

    // ==========================
    // 🟢 COD FLOW
    // ==========================
    if (!isDigital) {
      await _clearCartAndNavigate(vendorId);
      return;
    }

    // ==========================
    // 🔵 DIGITAL FLOW
    // ==========================
    final sessionId = orderResponse["paymentSessionId"]?.toString() ?? "";
    final orderId = orderResponse["orderId"]?.toString() ?? "";
    final paymentUrl = orderResponse["paymentUrl"]?.toString();
    final payableAmount = _extractPayableAmount(orderResponse);
    if (orderId.isEmpty) {
      setState(() {
        _isProcessing = false;
      });
      Get.snackbar("Payment Error", "Order created without a valid order ID");
      return;
    }
    await _handleDigitalPayment(
      gateway!,
      sessionId,
      orderId,
      paymentUrl: paymentUrl,
      amount: payableAmount,
    );
  }

  Future<bool> _clearCartAndNavigate(String vendorId) async {
    final itemsToDelete = List.from(widget.cartCtrl.cart.value?.items ?? []);
    var allRemoved = true;

    for (var item in itemsToDelete) {
      final removed = await widget.cartCtrl.removeItem1(
        cartItemId: item.cartItemId,
        VendorId: vendorId,
      );
      allRemoved = allRemoved && removed == true;
    }

    await widget.cartCtrl.loadCart(vendorId);

    if (!allRemoved) {
      Get.snackbar(
        "Order Placed",
        "Order was created, but some cart items could not be cleared automatically.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    Get.back();
    Get.off(() => OrdersReturnScreen());
    return allRemoved;
  }

  Future<void> saveAddress(SavedAddress address) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> stored = prefs.getStringList("saved_addresses") ?? [];

    final List<dynamic> decoded = stored.map((e) => jsonDecode(e)).toList();

    decoded.add(address.toJson());

    final List<String> encoded = decoded.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList("saved_addresses", encoded);
  }

  Future<List<SavedAddress>> loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getStringList("saved_addresses") ?? [];

    return stored.map((e) => SavedAddress.fromJson(jsonDecode(e))).toList();
  }

  Future<void> _handleDigitalPayment(
    Map<String, dynamic> gateway,
    String sessionId,
    String orderId, {
    String? paymentUrl,
    double? amount,
  }) async {
    currentOrderId = orderId;
    final String title = gateway["title"]?.toString().toUpperCase() ?? "";
    final String apiKey = gateway["apiKey"]?.toString() ?? "";

    switch (title) {
      case "RAZORPAY":
        if (sessionId.isEmpty ||
            apiKey.isEmpty ||
            amount == null ||
            amount <= 0) {
          setState(() {
            _isProcessing = false;
          });
          Get.snackbar("Payment Error", "Razorpay session is incomplete");
          return;
        }
        _openRazorpay(apiKey, sessionId, amount);
        break;
      case "PHONEPE":
        if (paymentUrl == null || paymentUrl.isEmpty) {
          setState(() {
            _isProcessing = false;
          });
          Get.snackbar("Payment Error", "PhonePe payment URL missing");
          return;
        }
        await _openPhonePePayment(paymentUrl);
        break;

      default:
        setState(() {
          _isProcessing = false;
        });
        Get.snackbar("Payment Error", "Unsupported payment gateway");
    }
  }
}

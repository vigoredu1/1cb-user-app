import 'package:flutter/material.dart';

class BuyProductProvider with ChangeNotifier {
  // Controllers for text fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  // State for the Information dropdown.
  bool isInfoExpanded = false;

  void toggleInfoExpansion() {
    isInfoExpanded = !isInfoExpanded;
    notifyListeners();
  }

  // Function to process the purchase.
  void buyProduct() {
    // For demonstration, print the collected values.
    print("Name: ${nameController.text}");
    print("Last Name: ${lastNameController.text}");
    print("Email: ${emailController.text}");
    print("Phone: ${phoneController.text}");
    print("Country: ${countryController.text}");
    print("City: ${cityController.text}");
    print("Pincode: ${pincodeController.text}");
    print("Street Address: ${streetAddressController.text}");
    print("Postal Code: ${postalCodeController.text}");
    print("Comments: ${commentsController.text}");
    // Add further purchase processing logic here.
  }

  void disposeControllers() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    postalCodeController.dispose();
    commentsController.dispose();
    countryController.dispose();
    cityController.dispose();
    pincodeController.dispose();
  }
}

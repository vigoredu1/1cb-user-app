import 'package:flutter/material.dart';

class CheckoutController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final noteController = TextEditingController();

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    streetController.dispose();
    postalCodeController.dispose();
    noteController.dispose();
  }
}

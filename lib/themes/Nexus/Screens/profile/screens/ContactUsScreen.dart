import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:one_click_builder/themes/Nexus/NexusVendorId/vendorid.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final NexusVendorController vendorController =
    Get.find<NexusVendorController>();


  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // 🔥 DEMO SUCCESS (API call later)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Message sent successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 🧹 Clear fields
      nameController.clear();
      emailController.clear();
      messageController.clear();

      // Optional: close keyboard
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Drop Us A Line",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Use the form below to get in touch with the sales team",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              /// Name & Email
              Row(
                children: [
                  Expanded(
                    child: _inputField(
                      controller: nameController,
                      hint: "Your Name *",
                      validator: (v) =>
                          v!.trim().isEmpty ? "Name is required" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _inputField(
                      controller: emailController,
                      hint: "Your Email *",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v!.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Message
              _inputField(
                controller: messageController,
                hint: "Your Message *",
                maxLines: 5,
                validator: (v) =>
                    v!.trim().isEmpty ? "Message is required" : null,
              ),

              const SizedBox(height: 24),

              /// Send Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "SEND MESSAGE",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Store Info
              const Text(
                "Our Store",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
            Obx(() {
  if (vendorController.loading.value) {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        vendorController.address.value.isNotEmpty
            ? vendorController.address.value
            : "",
        style: const TextStyle(height: 1.5),
      ),
      const SizedBox(height: 8),
      Text(
        vendorController.mobile.value.isNotEmpty
            ? "Phone: ${vendorController.mobile.value}"
            : "",
      ),
      const SizedBox(height: 4),
      Text(
        vendorController.email.value.isNotEmpty
            ? "Email: ${vendorController.email.value}"
            : "",
      ),
    ],
  );
}),

            ],
          ),
        ),
      ),
    );
  }

  /// Reusable validated input field
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
 
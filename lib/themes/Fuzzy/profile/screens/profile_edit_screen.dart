import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/userprofile_provider.dart';
import '../../utility/app_theme.dart';
import '../../utility/images.dart';
import '../../widget/common_appbar.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadUserData(); // API call

    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppTheme.fromType(AppTheme.defaultTheme).backGroundColorMain,
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final user = userProvider.userResponse?.user;

            // ✅ Fallback dummy values agar data na ho
            final displayName =
            "${user?.firstName ?? "Guest"} ${user?.lastName ?? "User"}".trim();
            final email = user?.email ?? "guest@example.com";
            final phone = "+91 9876543210";
            final profilePic = user?.profilePicture;

            // controllers update karo (readonly fields ke liye safe hai)
            nameController.text = displayName;
            emailController.text = email;
            phoneController.text = phone;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const CommonAppBar(appName: "Profile", isIcon: true),
                  const SizedBox(height: 11),

                  // Avatar
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45), // make it circular
                      child: (profilePic != null && profilePic.isNotEmpty)
                          ? Image.network(
                        profilePic,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Images.ProfilePic,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.asset(
                        Images.ProfilePic,
                        width: 90,
                        height: 90, // fallback if null/empty
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Name
                  _buildTextField(
                    controller: nameController,
                    icon: Icons.person,
                    label: "Name",
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    icon: Icons.email,
                    label: "Email id",
                    enabled: false,
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  _buildTextField(
                    controller: phoneController,
                    icon: Icons.phone,
                    label: "Phone Number",
                    enabled: false,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Reusable textfield
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

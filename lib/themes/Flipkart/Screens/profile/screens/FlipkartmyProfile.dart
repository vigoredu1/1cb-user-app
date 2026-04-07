import 'package:flutter/material.dart';
import 'package:one_click_builder/themes/Fuzzy/utility/plugin_list.dart';

class FlipkartProfileDashboardScreen extends StatefulWidget {
  const FlipkartProfileDashboardScreen({super.key});

  @override
  State<FlipkartProfileDashboardScreen> createState() => _FlipkartProfileDashboardScreenState();
}

class _FlipkartProfileDashboardScreenState extends State<FlipkartProfileDashboardScreen> {




Future<Map<String, String>> _loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? '',
    'email': prefs.getString('email') ?? '',
    'mobile': prefs.getString('mobile') ?? '',
    'profilePicture': prefs.getString('profilePicture') ?? '',
  };
}


@override
void initState() {
  super.initState();
  _loadPrefs();
}

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: const Color(0xFF2874F0), // Flipkart blue
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: const Text(
        "My Profile",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
       
        
      ],
    ),
    body: FutureBuilder(
      future: _loadPrefs(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              _profileHeader(data),
              _profileForm(data),
            ],
          ),
        );
      },
    ),
  );
}
Widget _profileHeader(Map<String, String> data) {
  final avatar = data['profilePicture'] ?? '';

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 24),
    color: const Color(0xFF2874F0),
    child: Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: Colors.white,
            backgroundImage:
                avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? const Icon(Icons.person, size: 42)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.edit, size: 16),
            ),
          )
        ],
      ),
    ),
  );
}
Widget _profileForm(Map<String, String> data) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel("First Name"),
        _fieldValue(data['name']?.split(" ").first ?? ""),

        const SizedBox(height: 20),

        _fieldLabel("Last Name"),
        _fieldValue(data['name']?.split(" ").last ?? ""),

        const SizedBox(height: 30),

        
        const SizedBox(height: 30),

        _infoRow(
          title: "Mobile Number",
          value: data['mobile'] ?? "--",
          onTap: () {},
        ),

        const Divider(),

        _infoRow(
          title: "Email ID",
          value: data['email'] ?? "",
          onTap: () {},
        ),
      ],
    ),
  );
}
Widget _fieldLabel(String text) {
  return Text(
    text,
    style: const TextStyle(color: Colors.grey),
  );
}

Widget _fieldValue(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 16),
    ),
  );
}

Widget _infoRow({
  required String title,
  required String value,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
      
    ],
  );
}


  // =======================================================
  // PROFILE CARD
  // =======================================================
Widget _profileCard() {
  return FutureBuilder(
    future: _loadPrefs(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      final data = snapshot.data!;
      final name = data['name'] ?? '';
      final email = data['email'] ?? '';
      final avatar = data['profilePicture'] ?? '';
      final number = data['mobile']?? "";

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
              child:
                  avatar.isEmpty ? const Icon(Icons.person, size: 36) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}



  // =======================================================
  // STATUS COLOR
  // =======================================================
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

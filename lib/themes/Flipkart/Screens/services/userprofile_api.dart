// import 'package:flutter/material.dart';
// import 'package:one_click_builder/themes/Nexus/Screens/Home/SiginScreen/signinScreen.dart';
// import 'package:shared_preferences/shared_preferences.dart';



// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   /// CHECK LOGIN STATUS
//   Future<bool> _isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('user_id');
//     return userId != null && userId.isNotEmpty;
//   }

//   /// LOGIN REQUIRED POPUP
//   void _showLoginRequiredDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Login Required"),
//         content: const Text("Please login to access this feature."),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) =>  NexusSignInScreen()),
//               );
//             },
//             child: const Text("Login"),
//           ),
//         ],
//       ),
//     );
//   }

//   /// COMMON HANDLER FOR ALL ITEMS
//   void _handleItemClick(BuildContext context, VoidCallback onSuccess) async {
//     final loggedIn = await _isLoggedIn();
//     if (!loggedIn) {
//       _showLoginRequiredDialog(context);
//       return;
//     }
//     onSuccess();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _sectionTitle("Account Settings"),
//             _card([
//               _item(
//                 context,
//                 Icons.person_outline,
//                 "Edit Profile",
//                 () {
//                   // Navigate to Edit Profile
//                 },
//               ),
//               _item(
//                 context,
//                 Icons.credit_card,
//                 "Saved Credit / Debit & Gift Cards",
//                 () {},
//               ),
//               _item(
//                 context,
//                 Icons.location_on_outlined,
//                 "Saved Addresses",
//                 () {},
//               ),
//               _item(
//                 context,
//                 Icons.language,
//                 "Select Language",
//                 () {},
//               ),
//               _item(
//                 context,
//                 Icons.notifications_outlined,
//                 "Notification Settings",
//                 () {},
//               ),
//               _item(
//                 context,
//                 Icons.lock_outline,
//                 "Privacy Center",
//                 () {},
//               ),
//             ]),

//             // _sectionTitle("My Activity"),
//             // _card([
//             //   _item(context, Icons.rate_review_outlined, "Reviews", () {}),
//             //   _item(
//             //     context,
//             //     Icons.question_answer_outlined,
//             //     "Questions & Answers",
//             //     () {},
//             //   ),
//             // ]),

//             // _sectionTitle("Earn with Flipkart"),
//             // _card([
//             //   _item(context, Icons.storefront_outlined, "Sell on Flipkart", () {}),
//             // ]),

//             // _sectionTitle("Feedback & Information"),
//             // _card([
//             //   _item(
//             //     context,
//             //     Icons.description_outlined,
//             //     "Terms, Policies and Licenses",
//             //     () {},
//             //   ),
//             //   _item(context, Icons.help_outline, "Browse FAQs", () {}),
//             // ]),

//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//     );
//   }

//   // SECTION TITLE
//   Widget _sectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   // CARD WRAPPER
//   Widget _card(List<Widget> children) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(children: children),
//     );
//   }

//   // LIST ITEM (LOGIN CHECK ENABLED)
//   Widget _item(
//     BuildContext context,
//     IconData icon,
//     String title,
//     VoidCallback onSuccess,
//   ) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Icon(icon, color: Colors.blue),
//           title: Text(title),
//           trailing: const Icon(Icons.chevron_right),
//           onTap: () => _handleItemClick(context, onSuccess),
//         ),
//         const Divider(height: 1),
//       ],
//     );
//   }
// }

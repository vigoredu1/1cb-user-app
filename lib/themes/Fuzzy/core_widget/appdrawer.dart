import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


import '../controller/userprofile_provider.dart';
//
// class AppDrawer extends StatefulWidget {
//   const AppDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     final drawerProvider = Provider.of<DrawerProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
//
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Profile Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 24,
//                     backgroundImage: (userProvider.userResponse != null &&
//                         userProvider.userResponse!.user.profilePicture != null &&
//                         userProvider.userResponse!.user.profilePicture!.isNotEmpty)
//                         ? NetworkImage(userProvider.userResponse!.user.profilePicture!)
//                         : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       "Hello ${userProvider.userResponse?.user.firstName ?? "User"}!",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Divider(height: 1),
//
//
//
//             const Divider(height: 1),
//
//             // Page List
//             ListTile(
//               title: const Text("Page List"),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (context) => const DashboardScreen()),
//                 );
//               },
//             ),
//
//             // Settings
//             ListTile(
//               title: const Text("Settings"),
//               onTap: () {},
//             ),
//
//             // Spacer pushes logout to bottom
//             const Spacer(),
//
//             // Logout
//             Consumer<UserProvider>(
//               builder: (context, userProvider, child) {
//                 if (userProvider.userResponse != null) {
//                   return ListTile(
//                     title: const Text("LogOut"),
//                     onTap: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text("Confirm Logout"),
//                             content: const Text("Are you sure you want to logout?"),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text("Cancel"),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   StorageHelper.removeToken();
//                                   Navigator.pop(context);
//                                   Navigator.of(context).pushReplacement(
//                                     MaterialPageRoute(builder: (context) => const LoginPage()),
//                                   );
//                                 },
//                                 child: const Text("Logout"),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   );
//                 } else {
//                   return ListTile(
//                     title: const Text("Login"),
//                     onTap: () {
//                       Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (context) => const LoginPage()),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import '../utility/images.dart';
import '../utility/local_storage.dart';
import '../view/screen/authentication/login/login_page.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Header with Profile Dynamic
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                final user = userProvider.userResponse?.user;

                final String displayName =
                "${user?.firstName ?? ""} ${user?.lastName ?? ""}".trim().isEmpty
                    ? "Guest User"
                    : "${user?.firstName ?? ""} ${user?.lastName ?? ""}".trim();

                final String? profilePic = user?.profilePicture;
                final String? email = user?.email;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45),
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
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello \n $displayName!",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (email != null && email.isNotEmpty)
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            // RTL Switch
            SwitchListTile(
              title: const Text("RTL"),
              value: false,
              onChanged: (val) {},
            ),
            const Divider(),

            // Dark Mode Switch
            SwitchListTile(
              title: const Text("Dark"),
              value: false,
              onChanged: (val) {},
            ),
            const Divider(),

            // Page List
            ListTile(
              title: const Text("Page List"),
              onTap: () {},
            ),
            const Divider(),

            // Settings
            ListTile(
              title: const Text("Settings"),
              onTap: () {},
            ),
            const Divider(),

            // ✅ Login / Logout Dynamic
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.userResponse != null) {
                  return ListTile(
                    title: const Text("Logout"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm Logout"),
                            content: const Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await StorageHelper.removeToken();
                                  Navigator.pop(context);
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  return ListTile(
                    title: const Text("Login"),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}


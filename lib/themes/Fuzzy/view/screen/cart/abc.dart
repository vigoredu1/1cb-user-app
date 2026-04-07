import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import '../../../controller/userprofile_provider.dart';
import '../../../service/wishlist_api.dart';
import '../../../utility/app_theme.dart';
import '../../../utility/svg_assets.dart';
import '../authentication/login/login_page.dart';

class WishlistButton extends StatefulWidget {
  final String productId;
  final String productImageId;

  const WishlistButton({super.key, required this.productId, required this.productImageId});

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);

    if (userProvider.userResponse != null &&
        wishlistProvider.wishlistItems.isEmpty) {
      wishlistProvider.fetchWishlistIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, WishlistProvider>(
      builder: (context, userProvider, wishlistProvider, child) {
        final isInWishlist =
            wishlistProvider.wishlistItems.contains(widget.productId);

        return GestureDetector(
          onTap: () async {
            if (userProvider.userResponse == null) {
              _showLoginDialog(context);
            } else {
              await wishlistProvider.toggleWishlist(
                productId: widget.productId,
                context: context, productImageId: widget.productImageId,
              );
            }
          },
          child: Align(
            alignment: Alignment.topRight,
            child: Container(

            margin:
            EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.02),
            padding:  const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color:  AppTheme.fromType(AppTheme.defaultTheme).whiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.fromType(AppTheme.defaultTheme)
                        .primaryColor
                        .withOpacity(0.10),
                    spreadRadius: 2,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                isInWishlist
                    ? SvgAssets.iconWishlistOne
                    : SvgAssets.iconWishlistTwo,
                height: 15,
                width: 15,
                // color: isInWishlist ? Colors.red : Colors.black54,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Not Logged In"),
        content: const Text("Please login to manage wishlist."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}

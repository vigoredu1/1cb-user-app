class AppConstant {
  ///https://testabc.apkaprachar.com AND https://stage.1clickbuilder.in facing error
// static const String baseUrl1 = 'https://testabc.apkaprachar.com';
  // static const String baseUrl2 = 'https://stage.1clickbuilder.in';
  // static const String baseUrl = 'https://urbantick.shop';

  static const String baseUrl = 'https://api.1clickbuilder.com';
  static const String registerUrl = '/api/user/customer-register';
  static const String loginUrl = '/api/user/login';

  static const String category = '/api/category/get-category';
  static const String product = '/api/product/get-products';
  static const String productetail = '/api/product/get-product';
  static const String bannerUrl = '/api/banner/banner-list/';
  static const String userprpfile_Url = '/api/user/profile';
  static const String vendorIdURl = '/api/logo/logo/urbantick.shop';
  // static const String vendorIdURl = '/api/logo/logo/apkaprachar.com';
  static const String bestSellingProduct =
      '/api/product/best-seller-product-list/';
  static const String checkoutCreateOrderUrl = '/api/order/create-order';
  // static const String bestSellingProduct =
  //     '/api/product/best-seller-product-list/';

  static const String product_list = '/api/product/product-list/';
  static const String catUrl = '/api/cart/';
  static const String remove_cartUrl = '/api/cart/remove-item/';
  static const String update_cartUrl = '/api/cart/update-item/';

  static const String about_Url =
      '/api/page-service/about/';
  static const String retrun_Url =
      '/api/page-service/return/';

  static const String terms_Url =
      '/api/page-service/terms/';
  static const String privacy_Url =
      '/api/page-service/privacy/';
  static const String cancellation_Url =
      '/api/page-service/cancellation/';
  //WISHLIST URLS

  static const String wishlistUrl = '/api/wishlist/add-product-to-wishlist';
  static const String wishlistRemoveUrl = '/api/wishlist/remove-product';
  static const String allWishlistGetUrl = '/api/wishlist/';

  static const String addToCartUrl = '/api/cart/add-cart/';
}

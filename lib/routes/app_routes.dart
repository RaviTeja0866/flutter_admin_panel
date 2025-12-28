import 'package:get/get.dart';
import 'package:roguestore_admin_panel/features/authentication/screens/forget_password/forget_password.dart';
import 'package:roguestore_admin_panel/features/authentication/screens/reset_password/reset_password.dart';
import 'package:roguestore_admin_panel/features/personalization/screens/auditlogs/auditlogs.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/all_coupons/coupons.dart';
import 'package:roguestore_admin_panel/features/shop/screens/coupons/create_coupon/create_coupon.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/all_exchange/exchange.dart';
import 'package:roguestore_admin_panel/features/shop/screens/exchange/exchnage_details/exchange_detail.dart';
import 'package:roguestore_admin_panel/features/shop/screens/orders/order_details/order_detail.dart';
import 'package:roguestore_admin_panel/features/shop/screens/returns/return_details/return_detail.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/all_shop_categories/shop_category.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/create_shop_category/create_shop_category.dart';
import 'package:roguestore_admin_panel/features/shop/screens/shop_category/edit_shop_category/edit_shop_category.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/all_size_guide/size_guide.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/create_size_guide/create_size_guide.dart';
import 'package:roguestore_admin_panel/features/shop/screens/size_guide/edit_size_guide/edit_size_guide.dart';
import 'package:roguestore_admin_panel/routes/routes.dart';
import 'package:roguestore_admin_panel/routes/routes_middleware.dart';

import '../features/authentication/screens/login/login_screen.dart';
import '../features/media/screens/media/media.dart';
import '../features/personalization/screens/profile/profile.dart';
import '../features/personalization/screens/settings/settings.dart';
import '../features/shop/screens/banner/all_banners/banners.dart';
import '../features/shop/screens/banner/create_banner/create_banner.dart';
import '../features/shop/screens/banner/edit_banner/edit_banner.dart';
import '../features/shop/screens/brand/all_brands/brands.dart';
import '../features/shop/screens/brand/create_brand/create_brand.dart';
import '../features/shop/screens/brand/edit_brand/edit_brand.dart';
import '../features/shop/screens/category/all_categories/categories.dart';
import '../features/shop/screens/category/create_category/create_category.dart';
import '../features/shop/screens/category/edit_category/edit_category.dart';
import '../features/shop/screens/coupons/edit_coupon/edit_coupon.dart';
import '../features/shop/screens/customer/all_customers/customers.dart';
import '../features/shop/screens/customer/customer_details/customer_details.dart';
import '../features/shop/screens/dashboard/dashboard.dart';
import '../features/shop/screens/orders/all_orders/orders.dart';
import '../features/shop/screens/product/all_products/products.dart';
import '../features/shop/screens/product/create_product/create_product.dart';
import '../features/shop/screens/product/edit_product/edit_product.dart';
import '../features/shop/screens/returns/all_returns/returns.dart';

class RSAppRoute{
  static final List<GetPage> pages = [
    
    GetPage(name: RSRoutes.login, page: ()=> const LoginScreen()),
    GetPage(name: RSRoutes.forgetPassword, page: ()=> const ForgetPasswordScreen()),
    GetPage(name: RSRoutes.resetPassword, page: ()=> const ResetPasswordScreen()),
    GetPage(name: RSRoutes.dashboard, page: ()=> const DashbaordScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.media, page: ()=> const MediaScreen(), middlewares: [RSRouteMiddleware()]),

    // Categories
    GetPage(name: RSRoutes.categories, page: ()=> const CategoriesScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createCategory, page: ()=> const CreateCategoryScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editCategory, page: ()=> const EditCategoryScreen(), middlewares: [RSRouteMiddleware()]),

    /// Brands
    GetPage(name: RSRoutes.brands, page: ()=> const BrandsScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createBrand, page: ()=> const CreateBrandScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editBrand, page: ()=> const EditBrandScreen(), middlewares: [RSRouteMiddleware()]),

    //Banners
    GetPage(name: RSRoutes.banners, page: ()=> const BannerScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createBanner, page: ()=> const CreateBannerScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editBanner, page: ()=> const EditBannerScreen(), middlewares: [RSRouteMiddleware()]),

    //Products
    GetPage(name: RSRoutes.products, page: ()=> const ProductScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createProduct, page: ()=> const CreateProductScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editProduct, page: ()=> const EditProductScreen(), middlewares: [RSRouteMiddleware()]),

    ///Customers
    GetPage(name: RSRoutes.customers, page: ()=> const CustomersScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.customerDetails, page: ()=> const CustomerDetailsScreen(), middlewares: [RSRouteMiddleware()]),

    ///Orders
    GetPage(name: RSRoutes.orders, page: ()=> const OrdersScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.orderDetails, page: ()=> const OrderDetailScreen(), middlewares: [RSRouteMiddleware()]),

    GetPage(name: RSRoutes.exchange, page: ()=> const ExchangeScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.returns, page: ()=> const ReturnsScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.exchangeDetails, page: ()=> const ExchangeDetailScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.returnsDetails, page: ()=> const ReturnDetailScreen(), middlewares: [RSRouteMiddleware()]),

    // Coupons
    GetPage(name: RSRoutes.coupons, page: ()=> const CouponScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createCoupon, page: ()=> const CreateCouponScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editCoupon, page: ()=> const EditCouponScreen(), middlewares: [RSRouteMiddleware()]),


    // Shop Category
    GetPage(name: RSRoutes.shopCategory, page: ()=> const ShopCategoryScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createShopCategory, page: ()=> const CreateShopCategoryScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editShopCategory, page: ()=> const EditShopCategory(), middlewares: [RSRouteMiddleware()]),


    // Size Guide
    GetPage(name: RSRoutes.sizeGuide, page: ()=> const SizeGuideScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.createSizeGuide, page: ()=> const CreateSizeGuideScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.editSizeGuide, page: ()=> const EditSizeGuideScreen(), middlewares: [RSRouteMiddleware()]),


    GetPage(name: RSRoutes.settings, page: ()=> const SettingsScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.auditLogs, page: ()=> const AuditlogsScreen(), middlewares: [RSRouteMiddleware()]),
    GetPage(name: RSRoutes.auditLogsExport, page: ()=> const AuditlogsScreen(), middlewares: [RSRouteMiddleware()]),


    GetPage(name: RSRoutes.profile, page: ()=> const ProfileScreen(), middlewares: [RSRouteMiddleware()]),


  ];
}
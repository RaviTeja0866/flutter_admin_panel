class RSRoutes {
  static List sideMenuItems = [dashboard, media, categories, brands, banners, products, customers, orders, settings, auditLogs, profile, coupons, adminUser];

  static const login = '/login';
  static const splash = '/splash';

  static const forgetPassword = '/forgetPassword';
  static const resetPassword = '/resetPassword';
  static const dashboard = '/dashboard';
  static const media = '/media';

  static const banners = '/banners';
  static const createBanner = '/createBanner';
  static const editBanner = '/editBanner/:id';

  static const products = '/products';
  static const createProduct = '/createProduct';
  static const editProduct = '/editProduct/:id';

  static const categories = '/categories';
  static const createCategory = '/createCategory';
  static const editCategory = '/editCategory/:id';

  static const brands = '/brands';
  static const createBrand = '/createBrand';
  static const editBrand = '/editBrand/:id';

  static const customers = '/customers';
  static const createCustomer = '/createCustomer';
  static const customerDetails = '/customerDetails';

  static const orders = '/orders';
  static const orderDetails = '/orders-details/:docId';

  static const exchange = '/exchange';
  static const returns = '/returns';
  static const exchangeDetails = '/exchange-details';
  static const returnsDetails = '/return-details';

  static const coupons = '/coupons';
  static const createCoupon = '/createCoupon';
  static const editCoupon = '/editCoupon/:id';

  static const shopCategory = '/shopCategory';
  static const createShopCategory = '/createShopCategory';
  static const editShopCategory = '/editShopCategory/:id';

  static const sizeGuide = '/sizeGuide';
  static const createSizeGuide = '/createSizeGuide';
  static const editSizeGuide = '/editSizeGuide/:id';

  static const settings = '/settings';

  static const auditLogs = '/auditLogs';
  static const auditLogsExport = '/auditLogs_export';

  static const profile = '/profile';
  static const accessDeniedScreen = '/accessDeniedScreen';

  static const adminUser = '/adminUser';
  static const createAdminUser = '/createAdminUser';
  static const editAdminUser = '/editAdminUser';

  static const roles = '/roles';
  static const createRole = '/createRole';
  static const editRole = '/editRole';


}

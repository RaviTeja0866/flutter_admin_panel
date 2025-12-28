/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

/// Switch of Custom Brand-Text-Size Widget
enum AppRole { admin, user }

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum TextSizes { small, medium, large }

enum ImageType { asset, network, memory, file }

enum MediaCategory { folders, banners, brands, categories, products, users }

enum OrderStatus { pending, processing, shipped, delivered, cancelled }
enum ExchangeStatus {
  pending,
  accepted,
  pickupScheduled,
  pickedUp,
  shipped,
  completed,
  cancelled,
  rejected,
}

enum ReturnStatus {
  pending,
  approved,
  pickupScheduled,
  pickedUp,
  received,
  refunded,
  completed,
  rejected,
  cancelled,
}

enum PaymentMethods { paypal, googlePay, applePay, visa, masterCard, creditCard, paystack, razorPay, paytm }

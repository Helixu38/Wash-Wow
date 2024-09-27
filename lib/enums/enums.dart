// enums.dart

enum Role {
  Admin,
  Customer,
  ShopOwner,
}

enum UserStatus {
  Unverified,
  Verified,
  Banned,
}

enum BookingStatus {
  Pending,
  Confirmed,
  Processing,
  Completed,
  Cancelled,
}

enum LaundryShopStatus {
  Open,
  Busy,
  Close,
}

enum VoucherType {
  DiscountByPercent,
  DiscountByAmount,
}

enum Role {
  Admin,
  Customer,
  ShopOwner,
}

extension RoleExtension on Role {
  String toShortString() {
    return toString().split('.').last;
  }

  static Role fromString(String roleString) {
    switch (roleString) {
      case 'Admin':
        return Role.Admin;
      case 'Customer':
        return Role.Customer;
      case 'ShopOwner':
        return Role.ShopOwner;
      default:
        throw Exception('Unknown role: $roleString');
    }
  }
}

enum UserStatus {
  Unverified,
  Verified,
  Banned,
}

extension UserStatusExtension on UserStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static UserStatus fromString(String statusString) {
    switch (statusString) {
      case 'Unverified':
        return UserStatus.Unverified;
      case 'Verified':
        return UserStatus.Verified;
      case 'Banned':
        return UserStatus.Banned;
      default:
        throw Exception('Unknown user status: $statusString');
    }
  }
}

enum BookingStatus {
  Pending,
  Confirmed,
  Processing,
  Completed,
  Cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static BookingStatus fromString(String statusString) {
    switch (statusString) {
      case 'Pending':
        return BookingStatus.Pending;
      case 'Confirmed':
        return BookingStatus.Confirmed;
      case 'Processing':
        return BookingStatus.Processing;
      case 'Completed':
        return BookingStatus.Completed;
      case 'Cancelled':
        return BookingStatus.Cancelled;
      default:
        throw Exception('Unknown booking status: $statusString');
    }
  }
}

enum LaundryShopStatus {
  Open,
  Busy,
  Close,
}

extension LaundryShopStatusExtension on LaundryShopStatus {
  String toShortString() {
    return toString().split('.').last;
  }

  static LaundryShopStatus fromString(String statusString) {
    switch (statusString) {
      case 'Open':
        return LaundryShopStatus.Open;
      case 'Busy':
        return LaundryShopStatus.Busy;
      case 'Close':
        return LaundryShopStatus.Close;
      default:
        throw Exception('Unknown laundry shop status: $statusString');
    }
  }
}

enum VoucherType {
  DiscountByPercent,
  DiscountByAmount,
}

extension VoucherTypeExtension on VoucherType {
  String toShortString() {
    return toString().split('.').last;
  }

  static VoucherType fromString(String voucherString) {
    switch (voucherString) {
      case 'DiscountByPercent':
        return VoucherType.DiscountByPercent;
      case 'DiscountByAmount':
        return VoucherType.DiscountByAmount;
      default:
        throw Exception('Unknown voucher type: $voucherString');
    }
  }
}

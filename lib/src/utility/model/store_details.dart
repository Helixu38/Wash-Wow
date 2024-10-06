class StoreDetails {
  String storeName;
  String address;
  String phoneNumber;
  String email;
  List<String> services;
  List<String> deviceTypes;
  List<String> images;

  StoreDetails({
    required this.storeName,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.services,
    required this.deviceTypes,
    required this.images,
  });

  @override
  String toString() {
    return 'StoreDetails(\n'
        '  storeName: $storeName,\n'
        '  address: $address,\n'
        '  phoneNumber: $phoneNumber,\n'
        '  email: $email,\n'
        '  services: ${services.join(', ')},\n'
        '  deviceTypes: ${deviceTypes.join(', ')},\n'
        '  images: ${images.join(', ')},\n'
        ')';
  }
}

class BookingItem {
  final String servicesId;

  BookingItem({required this.servicesId});

  Map<String, dynamic> toJson() {
    return {
      'servicesId': servicesId,
    };
  }
}


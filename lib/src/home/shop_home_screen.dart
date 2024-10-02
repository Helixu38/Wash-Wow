import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/extension/string_extension.dart';

class ShopOwnerHomeScreen extends StatefulWidget {
  const ShopOwnerHomeScreen({super.key});

  @override
  State<ShopOwnerHomeScreen> createState() => _ShopOwnerHomeScreenState();
}

class _ShopOwnerHomeScreenState extends State<ShopOwnerHomeScreen> {
  final AuthService authService = AuthService('https://10.0.2.2:7276');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopShopInformation(),
    );
  }

  PreferredSizeWidget buildTopShopInformation() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: FutureBuilder<String?>(
        future: authService.getUserName(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Loading...'),
              centerTitle: true,
            );
          } else if (snapshot.hasError) {
            return AppBar(
              title: const Text('Error loading user'),
              centerTitle: true,
            );
          } else {
            String shopName = snapshot.data ?? 'Unknown User';
            String shopLocation = "Lê Văn Việt, Hiệp Phú";

            return AppBar(
              title: buildShopProfile(shopName, shopLocation),
              centerTitle: true,
              backgroundColor: Colors.white,
            );
          }
        },
      ),
    );
  }

  Widget buildShopProfile(String shopName, String shopLocation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10), // Space between image and name
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chào, ${shopName.capitalize()}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(
                shopLocation,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ]),
      ],
    );
  }

  
}

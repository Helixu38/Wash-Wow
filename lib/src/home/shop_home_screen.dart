import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math' as math;
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
      body: buildContent(),
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

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          buildShopBalance(10000),
        ],
      ),
    );
  }

  Widget buildShopBalance(double shopBalance) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
        bottom: Radius.circular(30),
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          decoration: BoxDecoration(
            color:
                Theme.of(context).primaryColor.withOpacity(0.25), // 25% opacity
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(MdiIcons.walletBifold, color: Theme.of(context).primaryColor),
              const SizedBox(width: 5),
              Text(
                "$shopBalanceđ",
                style: TextStyle(
                  color: Theme.of(context).primaryColor, // Text color
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Transform.rotate(
                angle: 270 * math.pi / 180, // Rotating icon
                child: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ),
            ],
          )),
    );
  }
}

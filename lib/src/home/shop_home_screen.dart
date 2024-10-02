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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildShopBalance(10000),
          const SizedBox(height: 20),
          buildShopRevenue(1500000,1250000),
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
              Icon(MdiIcons.walletBifold,
                  color: Theme.of(context).primaryColor),
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

  Widget buildShopRevenue(double shopRevenue , double shopPastRevenue) {
    final formattedRevenue = formatCurrency(shopRevenue);
    final formattedPastRevenue = formatCurrency(shopPastRevenue);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              margin: EdgeInsets.zero,
              color: Color(0XFF0255C7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Container(
                  height: 114,
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Color(0XFF0255C7),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0XFF0853BB),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              "Doanh thu hôm nay",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "đ",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        formattedRevenue,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 28,
                                          ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left:10,top: 36),
                        child: Icon(
                          size:30,
                          MdiIcons.walletBifold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Text(
            "đ",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hôm qua",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                formattedPastRevenue,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

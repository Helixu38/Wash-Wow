import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  int order = 0; // Define instance variable
  double shopRating = 0.0; // Define instance variable
  double shopPastRating = 0.0; // Define instance variable

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
      child: FutureBuilder<Map<String, String?>>(
        future: authService.getUserInfo(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String?>> snapshot) {
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
            String shopName = snapshot.data?['fullName'] ?? 'Unknown Shop';
            String shopLocation = "Lê Văn Việt, Hiệp Phú";

            // Assign values to instance variables
            order = 10; // Example value
            shopRating = 4.9; // Example value
            shopPastRating = 4.5; // Example value

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShopBalance(10000),
            const SizedBox(height: 20),
            buildShopRevenue(1500000, 1250000),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: buildShopOrderAndRating(order, shopRating, shopPastRating),
            ),
            buildContentShop(
              card1: buildContentCard(
                height: 65,
                width: 65,
                icon: MdiIcons.briefcase,
                text: "Đơn hàng",
              ),
              card2: buildContentCard(
                height: 65,
                width: 65,
                icon: MdiIcons.washingMachine,
                text: "Tình trạng",
              ),
              card3: buildContentCard(
                height: 65,
                width: 65,
                icon: Icons.local_offer,
                text: "Khuyến mãi",
              ),
              card4: buildContentCard(
                height: 65,
                width: 65,
                icon: MdiIcons.bullhorn,
                text: "Quảng cáo",
              ),
              card5: buildContentCard(
                height: 65,
                width: 65,
                icon: MdiIcons.finance,
                text: "Tài chính",
              ),
              card6: buildContentCard(
                height: 65,
                width: 65,
                icon: MdiIcons.accountMultiple,
                text: "Nhân viên",
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              height: 20,
              thickness: 0.2,
              indent: 0,
              endIndent: 0,
              color: Colors.black,
            ),
            buildListViewNews("Có gì mới?"),
            const SizedBox(height: 20),
          ],
        ),
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

  Widget buildShopRevenue(double shopRevenue, double shopPastRevenue) {
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
                        margin: EdgeInsets.only(left: 10, top: 36),
                        child: Icon(
                          size: 30,
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

  Widget buildContentShop({
    required Widget card1,
    required Widget card2,
    required Widget card3,
    required Widget card4,
    required Widget card5,
    required Widget card6,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        children: [
          card1,
          card2,
          card3,
          card4,
          card5,
          card6,
        ],
      ),
    );
  }

  Widget buildContentCard({
    required double height,
    required double width,
    required IconData icon,
    required String text,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0X00000040).withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Icon(
            icon,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8), // Spacing between the card and the text
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  //Store list view
  Widget buildListViewNews(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    print('Xem thêm clicked');
                  },
                  child: Row(
                    children: [
                      Text(
                        "xem thêm",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180, // Rotating icon
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(width: 15),
              buildListViewNewsContent(
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                "Khuyến mãi",
                () {
                  // Define the action when the item is tapped
                  print('Discount 1 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewNewsContent(
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                "Khuyến mãi",
                () {
                  // Define the action when the item is tapped
                  print('Discount 2 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewNewsContent(
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                "Khuyến mãi",
                () {
                  // Define the action when the item is tapped
                  print('Discount 3 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewNewsContent(
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                "Khuyến mãi",
                () {
                  // Define the action when the item is tapped
                  print('Discount 4 clicked');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //What is new widget
// ListView News Content Widget
  Widget buildListViewNewsContent(
      String imageUrl, String labelText, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
          bottom: Radius.circular(18),
        ),
        child: Container(
          height: 90,
          width: 290,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              Center(
                child: Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text to stand out
                    shadows: [
                      Shadow(
                        offset:
                            Offset(1.5, 1.5), // Slight shadow for visibility
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShopOrderAndRating(
      int order, double shopRating, double shopPastRating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: "$order",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: " ", 
              ),
              TextSpan(
                text: "đơn hàng",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 10), 
        Container(
          height: 19, 
          width: 0.5, 
          color: Colors.black, 
        ),
        SizedBox(width: 10), 
      ],
    );
  }
}

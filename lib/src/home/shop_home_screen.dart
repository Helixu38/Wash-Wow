import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wash_wow/src/order/shop_order_screen.dart';
import 'dart:math' as math;
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/extension/string_extension.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class ShopOwnerHomeScreen extends StatefulWidget {
  const ShopOwnerHomeScreen({super.key});

  @override
  State<ShopOwnerHomeScreen> createState() => _ShopOwnerHomeScreenState();
}

class _ShopOwnerHomeScreenState extends State<ShopOwnerHomeScreen> {
  final AuthService authService = AuthService('https://washwowbe.onrender.com');

  int order = 10; // Define instance variable
  double shopRating = 4.9; // Define instance variable
  double shopPastRating = 4.5; // Define instance variable

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
                "Hello, ${shopName.capitalize()}",
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
    return FutureBuilder<List<dynamic>>(
      future: fetchLandryShopByOwnerID(1, 20), // Fetch shop data asynchronously
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final walletBalance = snapshot.data![0]
              ['wallet']; // Get wallet balance from the first shop

          // Now fetch the shop rating asynchronously
          return FutureBuilder<List<dynamic>>(
            future: fetchShopRating(
                snapshot.data![0]['id'].toString(), 1, 20), // Fetch shop rating
            builder: (BuildContext context,
                AsyncSnapshot<List<dynamic>> ratingSnapshot) {
              if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (ratingSnapshot.hasError) {
                return Center(child: Text('Error: ${ratingSnapshot.error}'));
              } else if (ratingSnapshot.hasData) {
                List<dynamic> ratings = ratingSnapshot.data!;

                double shopRating = ratings.isNotEmpty
                    ? ratings
                            .map((rating) => rating['rating'])
                            .reduce((a, b) => a + b) /
                        ratings.length
                    : 0; // Default to 0 if no ratings
                double shopPastRating = ratings.isNotEmpty
                    ? ratings
                            .map((rating) => rating['pastRating'])
                            .reduce((a, b) => a + b) /
                        ratings.length // Adjust as needed
                    : 0; // Default to 0 if no past ratings

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildShopBalance(
                            walletBalance), // Use dynamic wallet balance
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: buildShopOrderAndRating(
                            order, // Assuming `order` is defined somewhere
                            shopRating,
                            shopPastRating,
                          ),
                        ),
                        buildContentShop(
                          card1: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.briefcase,
                            text: "Order",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopOrderScreen()),
                              );
                            },
                          ),
                          card2: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.washingMachine,
                            text: "Status",
                            onTap: () {
                              print('Status tapped!');
                            },
                          ),
                          card3: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: Icons.local_offer,
                            text: "Discount",
                            onTap: () {
                              print('Discount tapped!');
                            },
                          ),
                          card4: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.bullhorn,
                            text: "Adds",
                            onTap: () {
                              print('Advertisement tapped!');
                            },
                          ),
                          card5: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.finance,
                            text: "Finance",
                            onTap: () {
                              print('Finance tapped!');
                            },
                          ),
                          card6: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.accountMultiple,
                            text: "Employee",
                            onTap: () {
                              print('Employee tapped!');
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 20,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        buildListViewNews("News?"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              } else {
                // If we reach here, it means ratings is not available
                double defaultRating = 0; // Set to 0 as default
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildShopBalance(walletBalance),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: buildShopOrderAndRating(
                            order, // Assuming `order` is defined somewhere
                            defaultRating,
                            defaultRating,
                          ),
                        ),
                        buildContentShop(
                          card1: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.briefcase,
                            text: "Order",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopOrderScreen()),
                              );
                            },
                          ),
                          card2: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.washingMachine,
                            text: "Status",
                            onTap: () {
                              print('Status tapped!');
                            },
                          ),
                          card3: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: Icons.local_offer,
                            text: "Discount",
                            onTap: () {
                              print('Discount tapped!');
                            },
                          ),
                          card4: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.bullhorn,
                            text: "Advertisement",
                            onTap: () {
                              print('Advertisement tapped!');
                            },
                          ),
                          card5: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.finance,
                            text: "Finance",
                            onTap: () {
                              print('Finance tapped!');
                            },
                          ),
                          card6: buildContentCard(
                            height: 65,
                            width: 65,
                            icon: MdiIcons.accountMultiple,
                            text: "Employee",
                            onTap: () {
                              print('Employee tapped!');
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 20,
                          thickness: 0.2,
                          color: Colors.black,
                        ),
                        buildListViewNews("News?"),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
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
                "Yesterday",
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
    required VoidCallback onTap, // Add onTap callback
  }) {
    return InkWell(
      onTap: onTap, // Action to trigger when the card is tapped
      borderRadius:
          BorderRadius.circular(12), // Ripple effect respects border radius
      child: Column(
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
      ),
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
                        "More",
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
        buildStarRating(shopRating, shopPastRating),
      ],
    );
  }

  Widget buildStarRating(double shopRating, double shopPastRating) {
    int fullStars = shopRating.floor(); // Number of full stars
    bool hasHalfStar =
        (shopRating - fullStars) >= 0.5; // Check if there is a half-star
    int totalStars = 5;

    // Calculate the difference between current and past rating
    double ratingDifference = shopRating - shopPastRating;
    bool isPositive = ratingDifference > 0;

    // Format the rating difference to 1 decimal place
    String ratingDifferenceText = ratingDifference.toStringAsFixed(1);
    String displayDifference =
        isPositive ? "+$ratingDifferenceText" : "$ratingDifferenceText";

    return Row(
      children: [
        // The star rating
        Row(
          children: List.generate(totalStars, (index) {
            if (index < fullStars) {
              // Full star
              return const Icon(Icons.star, color: Color(0xFFFFD43E), size: 24);
            } else if (index == fullStars && hasHalfStar) {
              // Half star
              return const Icon(Icons.star_half,
                  color: Color(0xFFFFD43E), size: 24);
            } else {
              // Empty star
              return const Icon(Icons.star_border,
                  color: Color(0xFFFFD43E), size: 24);
            }
          }),
        ),
        SizedBox(width: 6),
        // The rating text
        Text(
          "$shopRating",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 6),
        // Improvement or decline text
        Text(
          displayDifference,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: isPositive
                ? Colors.green
                : Colors.red, // Green if positive, red if negative
          ),
        ),
      ],
    );
  }
}

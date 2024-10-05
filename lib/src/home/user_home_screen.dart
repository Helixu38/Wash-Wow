import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:wash_wow/mock/data.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'dart:math' as math;
import "../utility/extension/string_extension.dart";
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final AuthService authService = AuthService('https://10.0.2.2:7276');
  static const RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopNavBar(),
      body: buildContent(),
    );
  }

  //Widget for top app bar
  PreferredSizeWidget buildTopNavBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: FutureBuilder<String?>(
        future: authService.getUserName(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppBar(
              title: const Text('Loading...'),
              centerTitle: true,
            );
          } else if (snapshot.hasError) {
            return AppBar(
              title: const Text('Error loading user'),
              centerTitle: true,
            );
          } else {
            String userName = snapshot.data ?? 'Unknown User';
            double userPoint = 2.222;

            return AppBar(
              title: buildUserProfile(userName, userPoint),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              shape: roundedRectangleBorder,
            );
          }
        },
      ),
    );
  }

  Widget buildUserProfile(String userName, double userPoint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfilePhoto(
          totalWidth: 40,
          cornerRadius: 20.0,
          outlineWidth: 0,
          outlineColor: Colors.transparent,
          color: Colors.transparent,
          image: const AssetImage('assets/images/avatar/placeholderavatar.png'),
        ),
        const SizedBox(width: 10), // Space between image and name
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.capitalize(),
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                'Điểm: $userPoint',
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ]),
      ],
    );
  }
  //Widget for top app bar

  //Widget for content
  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          const SizedBox(height: 15),
          buildListViewDiscount("Khuyến Mãi"),
          const SizedBox(height: 25),
          buildListServices("Dịch vụ"),
          const SizedBox(height: 25),
          buildListViewStore("Cửa hàng gần bạn"),
        ],
      ),
    );
  }

  Widget buildListViewDiscount(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
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
                        style: GoogleFonts.lato(
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
              buildListViewContentImage(146, 214, "test"),
              const SizedBox(width: 15),
              buildListViewContentImage(46, 214, "test"),
              const SizedBox(width: 15),
              buildListViewContentImage(146, 214, "test"),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListViewContentImage(
      double height, double width, String content) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
        bottom: Radius.circular(30),
      ),
      child: Container(
        height: height,
        width: width,
        color: Colors.amber[600],
        child: Center(
          child: Text(content, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
  //Store list view

  //Store list view
  Widget buildListViewStore(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
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
                        style: GoogleFonts.lato(
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
              buildListViewContentStore(
                118,
                116,
                4.9,
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                () {
                  // Define the action when the item is tapped
                  print('Store 1 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewContentStore(
                118,
                116,
                4.7,
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                () {
                  // Define the action when the item is tapped
                  print('Store 2 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewContentStore(
                118,
                116,
                3.6,
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                () {
                  // Define the action when the item is tapped
                  print('Store 3 clicked');
                },
              ),
              const SizedBox(width: 15),
              buildListViewContentStore(
                118,
                116,
                2.2,
                'https://firebasestorage.googleapis.com/v0/b/wash-wow-upload-image.appspot.com/o/images%2F90ffc8691501c6a60e1fe7d40eb7cd54.png?alt=media&token=a06b7771-b4de-4052-8a79-8d6936051035',
                () {
                  // Define the action when the item is tapped
                  print('Store 4 clicked');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListViewContentStore(double height, double width, double rating,
      String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
          bottom: Radius.circular(18),
        ),
        child: Container(
          height: height,
          width: width,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MdiIcons.star, color: Colors.yellow),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.black, // Text color
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ).frosted(
                        blur: 5,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Services List View
  Widget buildListServices(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
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
                        style: GoogleFonts.lato(
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
            children: services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => service.onTap(context), 
                  child: buildListViewServicesContent(
                      service.content, service.icon, service.onTap),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildListViewServicesContent(
      String content, IconData icon, void Function(BuildContext) onTap) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            child: Icon(
              icon,
              size: 70,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.center, // Center align the text
          ),
        ],
      ),
    );
  }

  //Services List View

  //Widget for content
}

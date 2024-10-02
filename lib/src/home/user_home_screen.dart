import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:wash_wow/src/services/auth_service.dart';
import 'dart:math' as math;
import "../services/extension/string_extension.dart";

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
            int notificationAmount = 1;

            return AppBar(
              title: buildUserProfile(userName, userPoint, notificationAmount),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              shape: roundedRectangleBorder,
            );
          }
        },
      ),
    );
  }

  Widget buildUserProfile(
      String userName, double userPoint, int notificationAmount) {
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
        Spacer(),
        IconButton(
          icon: Badge(
            label: Text('$notificationAmount'),
            child: const Icon(
              Icons.notifications_none_sharp,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            print("Notification have been pressed");
          },
        )
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
          const SizedBox(height: 10),
          buildListViewImage("Khuyến Mãi"),
          const SizedBox(height: 20),
          buildListServices("Dịch vụ"),
          const SizedBox(height: 20),
          buildListViewImage("Cửa hàng gần bạn"),
        ],
      ),
    );
  }

  Widget buildListViewImage(String title) {
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
            children: <Widget>[
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt thường", MdiIcons.cupWater),
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt sấy", MdiIcons.tumbleDryer),
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt giày", MdiIcons.shoeFormal),
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt chăn", MdiIcons.bedEmpty),
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt khô", MdiIcons.hairDryerOutline),
              const SizedBox(width: 20),
              buildListViewServicesContent("Giặt tẩy", MdiIcons.washingMachine),
            ],
          ),
        ),
      ],
    );
  }

  //TO DO : Update service to match with design
  Widget buildListViewServicesContent(String content, IconData icon) {
    return Column(
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
    );
  }

  //Services List View

  //Widget for content
}

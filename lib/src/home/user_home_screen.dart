import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:wash_wow/src/services/auth_service.dart';

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
      body: Center(
        child: Text('Welcome to the User Home Screen!'),
      ),
    );
  }

  //Widget for top app bar
  PreferredSizeWidget buildTopNavBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
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
                userName,
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
}

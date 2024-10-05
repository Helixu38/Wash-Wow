import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_photo/profile_photo.dart';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wash_wow/form/shop_register_form.dart';
import 'package:wash_wow/src/login/login_screen.dart';
import 'package:wash_wow/src/utility/auth_service.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthService authService = AuthService('https://10.0.2.2:7276');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Modify the Future to fetch both userName and userRole
      body: FutureBuilder<Map<String, String?>>(
        future: authService.getUserInfo(), // Fetch both userName and userRole
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show a loading spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data has been fetched successfully
            String userName = snapshot.data?['fullName'] ?? 'Unknown User';
            String userRole = snapshot.data?['role'] ??
                'Null'; 

            return Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 42),
                    Text(
                      'Tài khoản',
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 42),
                    ProfilePhoto(
                      totalWidth: 87,
                      cornerRadius: 66.5,
                      outlineWidth: 0,
                      outlineColor: Colors.transparent,
                      color: Colors.transparent,
                      image: const AssetImage(
                          'assets/images/avatar/placeholderavatar.png'),
                    ),
                    Text(
                      userName,
                      style: GoogleFonts.lato(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 33),
                    Column(
                      children: [
                        _buildRowItem(
                          context,
                          Icons.manage_accounts,
                          "Thông tin cá nhân",
                          () {
                            print("Thông tin cá nhân tapped");
                          },
                        ),
                        const SizedBox(height: 30),

                        // Conditionally render based on user role
                        if (userRole == "Customer") ...[
                          _buildRowItem(
                            context,
                            Icons.local_laundry_service_outlined,
                            "Đăng ký trở thành đối tác",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShopRegisterForm()));
                            },
                          ),
                          const SizedBox(height: 30),
                        ],

                        _buildRowItem(
                          context,
                          Icons.location_on,
                          "Quản lý địa chỉ",
                          () {
                            print("Quản lý địa chỉ tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          Icons.wallet,
                          "Phương thức thanh toán",
                          () {
                            print("Phương thức thanh toán tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          Icons.calendar_month,
                          "Đơn hàng của tôi",
                          () {
                            print("Đơn hàng của tôi tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          Icons.settings,
                          "Cài đặt",
                          () {
                            print("Cài đặt tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          CupertinoIcons.exclamationmark_circle,
                          "Trung tâm trợ giúp",
                          () {
                            print("Trung tâm trợ giúp tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          CupertinoIcons.lock,
                          "Quyền riêng tư",
                          () {
                            print("Quyền riêng tư tapped");
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildRowItem(
                          context,
                          Icons.logout,
                          "Đăng xuất",
                          () async {
                            bool success = await authService.logout();
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Logout failed. Please try again.'),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _buildRowItem(
    BuildContext context, IconData icon, String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Call the onTap function when tapped
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 43),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 18), // Spacing between icon and text
              Text(
                text,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Transform.rotate(
            angle: 270 * math.pi / 180, // Rotating icon
            child: Icon(
              Icons.expand_more,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}

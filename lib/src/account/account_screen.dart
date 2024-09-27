import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_photo/profile_photo.dart';
import 'dart:math' as math;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
              'Tên',
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
                    // Handle tap for Thong tin ca nhan
                    print("Thông tin cá nhân tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  Icons.location_on,
                  "Quản lý địa chỉ",
                  () {
                    // Handle tap for Quan ly dia chi
                    print("Quản lý địa chỉ tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  Icons.wallet,
                  "Phương thức thanh toán",
                  () {
                    // Handle tap for Phuong thuc thanh toan
                    print("Phương thức thanh toán tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  Icons.calendar_month,
                  "Đơn hàng của tôi",
                  () {
                    // Handle tap for Don hang cua toi
                    print("Đơn hàng của tôi tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  Icons.settings,
                  "Cài đặt",
                  () {
                    // Handle tap for Cai dat
                    print("Cài đặt tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  CupertinoIcons.exclamationmark_circle,
                  "Trung tâm trợ giúp",
                  () {
                    // Handle tap for Trung tam tro giup
                    print("Trung tâm trợ giúp tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  CupertinoIcons.lock,
                  "Quyền riêng tư",
                  () {
                    // Handle tap for Quyen rieng tu
                    print("Quyền riêng tư tapped");
                  },
                ),
                const SizedBox(height: 30),
                _buildRowItem(
                  context,
                  Icons.logout,
                  "Đăng xuất",
                  () {
                    // Handle tap for Dang xuat
                    print("Đăng xuất tapped");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildRowItem(BuildContext context, IconData icon, String text, VoidCallback onTap) {
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

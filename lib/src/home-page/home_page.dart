import 'package:flutter/material.dart';
import 'package:wash_wow/src/account/account_screen.dart';
import 'package:wash_wow/src/home/shop_home_screen.dart';
import 'package:wash_wow/src/home/user_home_screen.dart';
import 'package:wash_wow/src/notification/notification_screen.dart';
import 'package:wash_wow/src/order/order_screen.dart';

class HomePage extends StatefulWidget {     
  final String role;
  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    // Determine which home screen to display based on user role
    switch (currentPageIndex) {
      case 0:
        if (widget.role == 'Customer') {
          currentScreen = UserHomeScreen();
        } else if (widget.role == 'ShopOwner') {
          currentScreen = ShopOwnerHomeScreen(); // Add this line
        } else {
          currentScreen = UserHomeScreen(); // Fallback if the role is unknown
        }
        break;
      case 1:
        currentScreen = OrderScreen();
        break;
      case 2:
        currentScreen = NotificationScreen();
        break;
      case 3:
        currentScreen = AccountScreen();
        break;
      default:
        currentScreen = UserHomeScreen();
    }

    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
              (Set<WidgetState> states) => states.contains(WidgetState.selected)
                  ? const TextStyle(color: Colors.white)
                  : const TextStyle(color: Colors.white),
            ),
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            backgroundColor: Theme.of(context).primaryColor,
            indicatorColor: Colors.lightBlueAccent,
            selectedIndex: currentPageIndex,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined, color: Colors.white),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.notes, color: Colors.white),
                selectedIcon: Icon(Icons.notes_outlined, color: Colors.white),
                label: 'Đơn hàng',
              ),
              NavigationDestination(
                icon: Badge(
                    child: Icon(Icons.notifications_sharp, color: Colors.white)),
                label: 'Thông báo',
              ),
              NavigationDestination(
                selectedIcon:
                    Icon(Icons.account_circle_outlined, color: Colors.white),
                icon: Icon(Icons.account_circle_outlined, color: Colors.white),
                label: 'Tài khoản',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wash_wow/src/service/services_screen.dart';

class Service {
  final String content;
  final IconData icon;
  final void Function(BuildContext context) onTap; // Change this line

  Service({required this.content, required this.icon, required this.onTap});
}

final List<Service> services = [
  Service(
    content: 'Giặt thường',
    icon: MdiIcons.cupWater,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt thường is pressed");
    },
  ),
  Service(
    content: 'Giặt sấy',
    icon: MdiIcons.tumbleDryer,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt sấy is pressed");
    },
  ),
  Service(
    content: 'Giặt giày',
    icon: MdiIcons.shoeFormal,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt giày is pressed");
    },
  ),
  Service(
    content: 'Giặt chăn',
    icon: MdiIcons.bedEmpty,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt chăn is pressed");
    },
  ),
  Service(
    content: 'Giặt khô',
    icon: MdiIcons.hairDryerOutline,
    onTap: (context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt khô is pressed");
    },
  ),
  Service(
    content: 'Giặt tẩy',
    icon: MdiIcons.washingMachine,
    onTap: (context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen()),
      );
      print("Giặt tẩy is pressed");
    },
  ),
];

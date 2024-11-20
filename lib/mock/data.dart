import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wash_wow/src/service/services_screen.dart';

class Service {
  final String content;
  final IconData icon;
  final void Function(BuildContext context, String content) onTap;

  Service({
    required this.content,
    required this.icon,
    required this.onTap,
  });
}

final List<Service> services = [
  Service(
    content: 'Regular Laundry',  // "Giặt thường"
    icon: MdiIcons.cupWater,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
  Service(
    content: 'Dry Laundry',  // "Giặt sấy"
    icon: MdiIcons.tumbleDryer,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
  Service(
    content: 'Shoe Cleaning',  // "Giặt giày"
    icon: MdiIcons.shoeFormal,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
  Service(
    content: 'Bedding Laundry',  // "Giặt chăn"
    icon: MdiIcons.bedEmpty,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
  Service(
    content: 'Dry Cleaning',  // "Giặt khô"
    icon: MdiIcons.hairDryerOutline,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
  Service(
    content: 'Stain Removal',  // "Giặt tẩy"
    icon: MdiIcons.washingMachine,
    onTap: (context, content) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ServicesScreen(serviceName: content)),
      );
      print("$content is pressed");
    },
  ),
];


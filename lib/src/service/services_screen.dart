import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  final String serviceName;
  const ServicesScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Text(
          serviceName,
        ),
      ),
    );
  }

  //Widget for top app bar
  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            serviceName,
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
            ),
        ));
  }
}

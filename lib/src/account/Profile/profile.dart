import 'package:flutter/material.dart';
import 'package:wash_wow/src/service/services_screen.dart';
import 'package:wash_wow/src/utility/auth_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService authService = AuthService('https://washwowbe.onrender.com');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: FutureBuilder<Map<String, String?>>(
          future: authService.getUserInfo(),
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
              String userRole = snapshot.data?['role'] ?? 'Null';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 42),
                      Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          userName.isNotEmpty
                              ? userName
                              : 'Unknown User', // Replace with actual shop name
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Role",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromRGBO(4, 90, 208, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          userRole.isNotEmpty
                              ? userRole
                              : 'Unknown User', // Replace with actual shop name
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: ServicesScreen.roundedRectangleBorder,
          iconTheme: IconThemeData(color: Colors.white),
        ));
  }
}

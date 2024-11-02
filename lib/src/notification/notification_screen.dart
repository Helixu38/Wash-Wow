import 'package:flutter/material.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AuthService authService = AuthService('https://10.0.2.2:7276');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: buildNotificationList(),
    );
  }

  Widget buildNotificationList() {
    return FutureBuilder<List<dynamic>>(
      future: fetchNotifications("1", 1, 20),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<dynamic> notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              return buildNotificationCard(notification);
            },
          );
        } else {
          return const Center(child: Text('No notifications found'));
        }
      },
    );
  }

  Widget buildNotificationCard(dynamic notification) {
    // Check the status of the notification
    bool isUnread = notification['status'] == "Unread";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isUnread ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          isUnread ? Icons.notifications_active : Icons.notifications_none,
          color: isUnread ? Colors.white : Theme.of(context).primaryColor,
          size: 30,
        ),
        title: Text(
          '${notification['content']}',
          style: TextStyle(
            color: isUnread ? Colors.white : Colors.black,
            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        subtitle: isUnread
            ? const Text(
                'New!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle the tap event if needed
        },
      ),
    );
  }
}

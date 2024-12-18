import 'package:flutter/material.dart';
import 'package:wash_wow/src/utility/auth_service.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService authService = AuthService('https://washwowbe.onrender.com');
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
      future: fetchNotifications(1, 20),
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
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          String? notificationId = notification['id'];
          if (notificationId != null) {
            try {
              bool statusChanged =
                  await authService.changeNotificationStatus(notificationId);
              if (statusChanged) {
                // Optionally, show a snackbar to notify the user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification marked as read.')),
                );
                setState(() {
                  // Optionally update the state to reflect the change in UI
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Failed to mark notification as read.')),
                );
              }
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $error')),
              );
            }
          }
        },
      ),
    );
  }
}

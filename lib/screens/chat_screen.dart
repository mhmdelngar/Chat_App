import 'package:chat_app_max/widgets/chat/message_file.dart';
import 'package:chat_app_max/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fm = FirebaseMessaging();
    fm.requestNotificationPermissions();
    fm.configure(onLaunch: (mes) {
      print(mes);

      return;
    }, onResume: (mes) {
      print(mes);
      return;
    }, onMessage: (mes) {
      print(mes);
      return;
    });
    fm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Time'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 3,
                      ),
                      Text('Log Out')
                    ],
                  ))
            ],
            onChanged: (type) {
              if (type == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: MessagChat()), NewMessage()],
      ),
    );
  }
}

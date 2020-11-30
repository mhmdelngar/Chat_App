import 'package:chat_app_max/widgets/chat/message_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, streamSnapShot) {
        if (streamSnapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final documents = streamSnapShot.data.documents;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (ctx, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (context, i) => Container(
                    child: MessageUi(
                      message: documents[i]['text'],
                      isMe: documents[i]['userId'] == snapShot.data.uid,
                      userName: documents[i]['userName'],
                      imageUrl: documents[i]['image_user'],
                    ),
                    key: ValueKey(documents[i].documentID),
                  ),
                  itemCount: documents.length,
                );
              }),
        );
      },
    );
  }
}

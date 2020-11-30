import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var message = '';
  TextEditingController _controller = TextEditingController();

  setMessage() async {
    FocusScope.of(context).unfocus();
    final currentUser = await FirebaseAuth.instance.currentUser();
    final username = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    Firestore.instance.collection('/chat').add({
      'text': message,
      'time': Timestamp.now(),
      'userId': currentUser.uid,
      'image_user': username['imageUrl'],
      'userName': username['userName']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'send anew message'),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: message.trim().isEmpty ? null : setMessage,
          )
        ],
      ),
    );
  }
}

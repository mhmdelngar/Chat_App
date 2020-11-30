import 'dart:io';

import 'package:chat_app_max/widgets/auth/auth_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isAuth = false;

  final _auth = FirebaseAuth.instance;

  void authTheUser(
    String email,
    String userName,
    String password,
    bool isLogin,
    BuildContext ctx,
    File image,
  ) async {
    try {
      setState(() {
        isAuth = true;
      });
      AuthResult result;
      if (isLogin) {
        result = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      final imagePath = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(result.user.uid + '.jpg');
      await imagePath.putFile(image).onComplete;
      final url = await imagePath.getDownloadURL();

      await Firestore.instance
          .collection('users')
          .document(result.user.uid)
          .setData({
        'userName': userName,
        'email': email,
        'password': password,
        'imageUrl': url
      });
      setState(() {
        isAuth = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        isAuth = false;
      });
      var message = 'there is an error in your auth';
      if (error != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
      ));
    } catch (e) {
      setState(() {
        isAuth = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: authTheUser,
        isAuth: isAuth,
      ),
    );
  }
}

import 'dart:io';

import 'package:chat_app_max/widgets/picker/image_input_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(String email, String userName, String password, bool isLogin,
      BuildContext ctx, File image) submitFn;
  final bool isAuth;

  const AuthForm({this.submitFn, this.isAuth});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  String _email = '';
  String _userName = '';
  String _password = '';
  File _userImage;

  pickedImage(File image) {
    _userImage = image;
  }

  trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'you should add an image',
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_email.trim(), _userName.trim(), _password.trim(),
          _isLogin, context, _userImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin)
                      PickAnImage(
                        pickedImageFn: pickedImage,
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'enter availd email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('user name'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'user name is too short';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'user name'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'enter a vaild password (7 numbers)';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                        decoration: InputDecoration(labelText: 'password'),
                        obscureText: true),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.isAuth) CircularProgressIndicator(),
                    if (!widget.isAuth)
                      RaisedButton(
                        onPressed: trySubmit,
                        child: Text(_isLogin ? 'log in' : 'Sign up'),
                      ),
                    if (!widget.isAuth)
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'create email'
                            : 'I already have an email'),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

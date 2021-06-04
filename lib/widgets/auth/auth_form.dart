import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udemy_chat_app/widgets/pickers/user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;

  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); // for closing the keyboard

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return null;
    }
    if (isValid) {
      _formKey.currentState.save(); //trigger onSaved method
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
      );
      // Use Those values to send auth request
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage,
                  ),
                  TextFormField(
                    key: ValueKey("email"),
                    validator: (val) {
                      if (val.isEmpty || !val.contains("@")) {
                        return "Please enter a valid email address.";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return "Please enter at least 4 characters";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(labelText: "Username"),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return "Password must be at least 7 characters long.";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? "Login" : "Register"),
                      onPressed: _trySubmit,
                    ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(_isLogin
                        ? "Create new Account"
                        : "I already have an account"),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

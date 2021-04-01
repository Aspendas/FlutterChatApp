import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat_app/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
      String email, String password, String username, bool isLogin) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if(isLogin){
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance.collection("users").doc(userCredential.user.uid).set({
          "username" : username,
          "email" : email,
        });
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (error){
      var message = "An error occurred, please check your credentials";

      if (error.message != null) {
        message = error.message;
      }
      setState(() {
        _isLoading = false;
      });

      Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Theme.of(context).errorColor,),);
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

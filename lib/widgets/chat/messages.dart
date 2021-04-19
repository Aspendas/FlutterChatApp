import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Query chat = FirebaseFirestore.instance
        .collection('chat')
        .orderBy("createdAt", descending: true);
    return StreamBuilder(
      stream: chat.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          reverse: true,
          children: snapshot.data.docs.map((DocumentSnapshot document) {
                return
                  MessagesBubble(
                  message: document.data()["text"],
                  username: document.data()["username"],
                  isMe: document.data()["userId"] == FirebaseAuth.instance.currentUser.uid.toString(),

                );
          }).toList(),
        );
      },
    );
  }
}

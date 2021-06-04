import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessagesBubble extends StatelessWidget {
  const MessagesBubble({Key key, this.message, this.isMe, this.username, this.userImage})
      : super(key: key);

  final String message;
  final String userImage;
  final bool isMe;
  final String username;

  @override
  Widget build(BuildContext context) {
    return
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              constraints: BoxConstraints(
                  minWidth: 20,
                  maxWidth: MediaQuery.of(context).size.width * 2 / 3),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
                children: [

                       Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).accentTextTheme.title.color,
                          ),
                        ),

                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.title.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

  }
}

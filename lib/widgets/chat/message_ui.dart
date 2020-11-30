import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageUi extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;
  final String imageUrl;

  MessageUi({this.message, this.isMe, this.userName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    12,
                  ),
                  topLeft: Radius.circular(
                    12,
                  ),
                  bottomRight: isMe
                      ? Radius.circular(
                          0,
                        )
                      : Radius.circular(
                          12,
                        ),
                  bottomLeft: !isMe
                      ? Radius.circular(
                          0,
                        )
                      : Radius.circular(12),
                ),
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 4,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              width: 180,
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).textTheme.bodyText2.color),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? null : 150,
          right: isMe ? 150 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}

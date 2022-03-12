import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext ctx, AsyncSnapshot chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.docs;
          // Error
          final Future<FirebaseAuth> firebaseAuth =
              FirebaseAuth.instance.currentUser as Future<FirebaseAuth>;
          return FutureBuilder(
              future: firebaseAuth,
              builder: (BuildContext ctx, AsyncSnapshot futureSnapshot) =>
                  ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, index) => MessageBubble(
                      message: chatDocs[index]['text'],
                      isMe: chatDocs[index]['userId'],
                    ),
                    itemCount: chatDocs.length,
                  ));
        });
  }
}

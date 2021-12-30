import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/userdata.dart';
import '../widgets/full_userdata.dart' as Allusers;
import 'dart:developer';

class AllMessages extends StatefulWidget {
  const AllMessages({Key? key}) : super(key: key);

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

//TODO;;SHOW ALL CONTACTS HERE AND SHOW THOSE ON TOP WHO HAVE SENT MESSGAGES THATS UNSEEN
class _AllMessagesState extends State<AllMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(User.userid.toString())
            .collection("userchats")
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          var z = (snap.data as QuerySnapshot<Map<String, dynamic>>).docs;
          log(z.length.toString() + " messgaes");
          // log(z[0]["sentby"].toString());
          // log(Allusers.l.where((element) {
          //   return element["uid"] == z[0]["sentby"];
          // }).toString());
          return ListView.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed("message_screen",
                      arguments: Allusers.l.firstWhere((element) {
                    return element["uid"] == z[index]["sentby"];
                  }));
                },
                child: ListTile(
                  tileColor: Colors.grey,
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(z[index]['username'].toString(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              );
            },
            itemCount: z.length,
          );
        });
  }
}

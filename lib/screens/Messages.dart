import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:placement_cell/userdata.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var user;
  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title: Text(user['username']),
          leadingWidth: 100,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
              CircleAvatar(
                child: user["imageurl"].toString().isEmpty
                    ? Icon(Icons.person)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(user["imageurl"])),
              ),
            ],
          )),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(User.userid)
              .collection(user["uid"])
              .get(),
          builder: (context, snap) {
            return Container();
          }),
    );
  }
}
//TODO::BODY OF MESSAGES

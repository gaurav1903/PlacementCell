import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:placement_cell/userdata.dart';
import 'dart:developer';

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
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(User.userid)
              .collection(user["uid"])
              .snapshots()
              .where((event) {
            log(event.docs[0].toString() + "event");
            return true;
          }),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return Column(
              children: [
                // ListView.builder(itemBuilder: (ctx, index) {
                //   return MessageBubble();
                // }),
                WriteBox(user)
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            );
          }),
    );
  }
}
//TODO::BODY OF MESSAGES
//TODO:: 1ST---->ONLY TEXT MESSAGES
//TODO:: 2ND--->IMAGES MESSAGES AND OPENS
//TODO:: 3RD --> FILES AND OPENS
//TODO:: 4TH-> FOLLOW FUNCTIONALITY

class WriteBox extends StatefulWidget {
  var user;
  WriteBox(this.user);
  @override
  _WriteBoxState createState() => _WriteBoxState();
}

class _WriteBoxState extends State<WriteBox> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Form(
          child: Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey),
              child: TextFormField(
                onChanged: (val) {
                  text = val;
                },
                maxLines: 20,
                minLines: 1,
                decoration: InputDecoration(hintText: "Write Message"),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              // FirebaseFirestore.instance.collection("users").doc(User.userid).collection(widget.user["uid"]).add({});
              setState(() {});
            },
            icon: Icon(Icons.arrow_forward))
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

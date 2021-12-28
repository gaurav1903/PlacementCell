import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:placement_cell/UserMessages.dart';
import 'package:placement_cell/userdata.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
// import '../widgets/Writebox.dart';
import 'package:shared_preferences/shared_preferences.dart';

//THIS IS FOR ONE PERSON ONLY SO WE HAVE TO SIMPLY GET FROM SHAREDPREFERENCES AND THEN LOOK AT DOCCHANGES
//no need to delete messages dont take much storage

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var user;
  // TextEditingController controller = TextEditingController();
  List messages =
      []; //after adding from shared preferences in form of a map for each message
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)?.settings.arguments;
    log(user.toString() + " user");
    return ChangeNotifierProvider<UserMessages>(
        create: (_) => UserMessages(),
        builder: (context, widget) {
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
                    .collection("chats")
                    .doc(User.userid.toString())
                    .collection("userchats")
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  log(User.userid.toString());

                  var z = (snap.data as QuerySnapshot<Map<String, dynamic>>)
                      .docChanges
                      .where((element) {
                    return element.doc['sentby'] == user['uid'];
                  }).toList();
                  var x = Provider.of<UserMessages>(context, listen: false);
                  messages += z.map((e) {
                    return e.doc;
                  }).toList();
                  if (x.messages.isEmpty) x.setmessages(messages);
                  // log(z.length.toString() + " look here at doc changes");
                  return Consumer<UserMessages>(
                      builder: (context, prod, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 50,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: MessageBubble(
                                      x.messages[index]["text"],
                                      x.messages[index]["sentby"] ==
                                          User.userid),
                                );
                              },
                              itemCount: x.messages.length,
                            ),
                          ),
                          WriteBox(user)
                        ],
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                      ),
                    );
                  });
                }),
          );
        });
  }
}
//TODO::BODY OF MESSAGES
//TODO:: 1ST---->ONLY TEXT MESSAGES
//TODO:: 2ND--->IMAGES MESSAGES AND OPENS
//TODO:: 3RD --> FILES AND OPENS
//TODO:: 4TH-> FOLLOW FUNCTIONALITY
//TODO::HOW TO DO IT?
//FIRST LOAD CACHE FROM SHAREDPREFERENCES THEN FROM DOCCHANGES
//DRAFT1 ->>LOAD ALL DOCS SIMPLY AND THEN GET ALL THE CHANGED

//TODO:: NEXT STEP WOULD BE TO ADD NEW MESSAGES TO SCREEN and shared preferences

class MessageBubble extends StatelessWidget {
  String text;
  bool me = false;
  MessageBubble(this.text, this.me);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          me == false ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width / 2,
          child: Text(text),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class WriteBox extends StatefulWidget {
  var user;
  TextEditingController controller = TextEditingController();
  // UserMessages msgs;
  WriteBox(this.user);
  @override
  _WriteBoxState createState() => _WriteBoxState();
}

class _WriteBoxState extends State<WriteBox> {
  String text = "";

  @override
  Widget build(BuildContext context) {
    var x = Provider.of<UserMessages>(context, listen: false);
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
                controller: widget.controller,
                maxLines: 20,
                minLines: 1,
                decoration: InputDecoration(hintText: "Write Message"),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              //ADD TO SHARED PREFERENCE
              FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.user['uid'].toString())
                  .collection("userchats")
                  .add({
                "text": text,
                "sentby": User.userid,
                "time": Timestamp.now(),
                "username": User.username,
              });
              x.setmessages(x.messages +
                  [
                    {
                      "sentby": User.userid,
                      "text": text,
                      "time": Timestamp.now(),
                      "username": User.username
                    }
                  ]);
              //TODO:: ADD IN SHARED PREFERENCE
              //TODO::ADD TO SCREEN
            },
            icon: Icon(Icons.arrow_forward))
      ],
    );
  }
}

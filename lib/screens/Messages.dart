import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:placement_cell/UserMessages.dart';
import 'package:placement_cell/userdata.dart';
import 'dart:developer';

import '../SqlHelper/Sql.dart';
import 'package:provider/provider.dart';
// import '../widgets/Writebox.dart';

//TODO::LOTS OF TESTING REMAINING
//TODO:: 2 TABLES FOR EACH USER
class Messages extends StatefulWidget {
  int streamcode = 0;
  Future f = Future.value();
  int first = 0;
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var user;
  final scrollcontroller = ScrollController();
  // TextEditingController controller = TextEditingController();
  List messages = [];
  List sentmsgs = [];
  List recvmsgs = [];

  Future<void> getdata() async {
    log("get data ran");
//TODO::SEE IF ONE FAILS OTHERS SHOULD STILL WORK
    await DBhelper.givemessages(user['uid'] + "recv").then((value) {
      log(value.toString());
      value.forEach((element) {
        recvmsgs.add(element);
        log(element.toString() + "forn db recvmsgs");
      });
    });
    await DBhelper.givemessages(user['uid'] + "sent").then((value) {
      value.forEach((element) {
        sentmsgs.add(element);
      });
    });
    log("lists fetched fform db " + recvmsgs.toString());
  }

  // Timestamp t = Timestamp.now();
  @override
  void initState() {
    widget.streamcode = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    user = ModalRoute.of(context)?.settings.arguments;
    widget.f = getdata();
    super.didChangeDependencies();
  }

  bool isfirst() {
    widget.first++;
    if (widget.first > 2)
      return false;
    else
      return true; //true
  }

  int update_streamcode() {
    widget.streamcode += 1;
    log("streammcode" + widget.streamcode.toString());
    return widget.streamcode % 2;
  }

  @override
  Widget build(BuildContext context) {
    log("this complete build ran");
    return FutureBuilder(
        future: widget.f,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            log(recvmsgs.toString() + " msgs " + sentmsgs.toString());
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
                          initialData:
                              recvmsgs, //TODO::CHANGE THIS AND SETUP MESSAGES  //check this properly
                          stream: FirebaseFirestore.instance
                              .collection("chats")
                              .doc(User.userid.toString())
                              .collection("userchats")
                              .where("sentby", isEqualTo: user['uid'])
                              .orderBy("time")
                              .snapshots()
                            ..listen((event) {
                              var z = Provider.of<UserMessages>(context,
                                  listen: false);
                              log("docs length" + event.docs.length.toString());
                              // sentmsgs = z.sentmsgs;
                              if (isfirst() == true) {
                                z.setsentmsgs(sentmsgs);
                                z.setrecvmsgs(recvmsgs);
                                int n = event.docChanges.toList().length -
                                    z.recvmsgs.length;
                                log(n.toString() + " n");
                                int lastindex = event.docChanges.length - 1;
                                while (n != 0) {
                                  var p = event.docChanges[lastindex].doc;
                                  recvmsgs.add(p.data());
                                  DBhelper.insert(user['uid'] + "recv", {
                                    'sentto': User.userid,
                                    'time': p.data()?['time'].toString(),
                                    'sentby': user['uid'],
                                    'msgid': p.id,
                                    'seen': 'TRUE',
                                    'text': p.data()?['text']
                                  });
                                  n--;
                                  lastindex--;
                                }
                                log("cheking db insert");
                                DBhelper.givemessages(user['uid'] + "recv")
                                    .then((value) {
                                  log(value.length.toString() + "value of db");
                                  value.forEach((element) {
                                    log(element.toString());
                                  });
                                });
                              }

                              if (event.docChanges.isNotEmpty &&
                                  isfirst() == false) {
                                scrollcontroller.animateTo(
                                    scrollcontroller.position.maxScrollExtent +
                                        65,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeInOut);
                                var x = event.docChanges.toList();
                                log("here is messages initially" +
                                    recvmsgs.toString());
                                recvmsgs += x.map((e) {
                                  DBhelper.insert(user['uid'] + "recv", {
                                    'sentto': User.userid,
                                    'time': e.doc.data()?['time'].toString(),
                                    'sentby': user['uid'],
                                    'msgid': e.doc.id,
                                    'seen': 'TRUE',
                                    'text': e.doc.data()?['text']
                                  });
                                  return e.doc.data();
                                }).toList();
                                log("cheking db insert");
                                DBhelper.givemessages(user['uid'] + "recv")
                                    .then((value) {
                                  log(value.length.toString() + "value of db");
                                  value.forEach((element) {
                                    log(element.toString());
                                  });
                                });
                                sentmsgs =
                                    z.sentmsgs; //TODO:: JUST TO HAVE IT IN SYNC
                              }
                              z.setrecvmsgs(recvmsgs);
                              // z.setsentmsgs(sentmsgs);

                              log("messages finally " + z.messages.toString());
                            }),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting)
                              return Center(child: CircularProgressIndicator());
                            log(User.userid.toString());

                            return Consumer<UserMessages>(
                                builder: (context, prod, child) {
                              return Container(
                                height: MediaQuery.of(context).size.height - 50,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        controller: scrollcontroller,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: MessageBubble(
                                                prod.messages[index]["text"],
                                                prod.messages[index]
                                                        ["sentby"] ==
                                                    User.userid),
                                          );
                                        },
                                        itemCount: prod.messages.length,
                                      ),
                                    ),
                                    WriteBox(user)
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                ),
                              );
                            });
                          }));
                });
          } else
            return Center(child: CircularProgressIndicator());
        });
  }
}
//TODO::BODY OF MESSAGES
//TODO:: 1ST---->ONLY TEXT MESSAGES
//TODO:: 2ND--->IMAGES MESSAGES AND OPENS
//TODO:: 3RD --> FILES AND OPENS
//TODO:: 4TH-> FOLLOW FUNCTIONALITY
//TODO::HOW TO DO IT?
//FIRST LOAD CACHE FROM SQLITE THEN FROM DOCCHANGES
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
              }).then((value) {
                DBhelper.insert(widget.user['uid'] + "sent", {
                  'sentto': widget.user['uid'],
                  'time': Timestamp.now().toString(),
                  'sentby': User.userid,
                  'msgid': value.id,
                  'seen': 'TRUE',
                  'text': text
                });
              });
              //TODO::HERE WE ACTUALLY HAVE TO MANAGE STATE FOR RECVMSGS AND SENTMSGS
              x.setsentmsgs(x.sentmsgs +
                  [
                    {
                      'sentto': widget.user['uid'],
                      "sentby": User.userid,
                      "text": text,
                      "time": Timestamp.now(),
                      "username": User.username,
                    }
                  ]);
              FocusScope.of(context).unfocus();

              //TODO:: ADD IN SHARED PREFERENCE
              //TODO::ADD TO SCREEN
            },
            icon: Icon(Icons.arrow_forward))
      ],
    );
  }
}

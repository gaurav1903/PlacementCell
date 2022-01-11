import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/userdata.dart';
import '../widgets/full_userdata.dart' as Allusers;
import 'dart:developer';

//WHAT TO DO->
//WE WILL MANTAIN ALL RECIEVEDD MESSAGES IN A TABLE THEN WE WILL RETRIEVE THIS TABLE AND make a list that will order them accordingly
//TODO:: A LOT OF OPTIMISATION FOR THIS PAGE AND LAY THE RULES AS WELL
class AllMessages extends StatefulWidget {
  const AllMessages({Key? key}) : super(key: key);

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

//TODO::SHOW ALL CONTACTS HERE AND SHOW THOSE ON TOP WHO HAVE SENT MESSGAGES THATS UNSEEN
class _AllMessagesState extends State<AllMessages> {
  List order = []; //should contain only uid
  Set<String> done = {};
  Future f = Future.value();
  Future<void> func() async {
    log(Allusers.l.length.toString() + "all users len in func on allmsgs");
    if (Allusers.l.isEmpty) {
      await FirebaseFirestore.instance.collection("users").get().then((val) {
        var z = val.docs;
        List temp = [];
        z.forEach((element) {
          if ((element.data() as Map<String, dynamic>).containsKey("batch") ||
              (element.data().containsKey("company"))) temp.add(element.data());
        });
        Allusers.setl(temp);
        Allusers.setpartialdata(temp);
      });
      log("func ran on allmessages");
    } else
      return;
  }

  @override
  void initState() {
    f = func();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: f,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(User.userid.toString())
                  .collection("userchats")
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                log(Allusers.l.length.toString() +
                    "allusers.l " +
                    Allusers.l[0].toString());
                var z = (snap.data as QuerySnapshot<Map<String, dynamic>>).docs;
                log(z.length.toString());
                for (int i = 0; i < z.length; i++) {
                  if (done.contains(z[i].data()['sentby']) == false) {
                    order.add(z[i].data()['sentby']);
                    done.add(z[i].data()['sentby']);
                  }
                }
                for (int i = 0; i < Allusers.l.length; i++) {
                  if (done.contains(Allusers.l[i]['uid']) == false &&
                      Allusers.l[i]['uid'] != User.userid) {
                    order.add(Allusers.l[i]['uid']);
                    done.add(Allusers.l[i]['uid']);
                  }
                }
                log(order.toString() + " orderrrrrrrrrrrrrrrrrrrrrrr");
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("message_screen",
                            arguments: Allusers.l.firstWhere((element) {
                          return element['uid'] == order[index];
                        }));
                      },
                      child: ListTile(
                        tileColor: Colors.grey,
                        leading: CircleAvatar(child: Icon(Icons.person)),
                        title: Text(
                            Allusers.l
                                .firstWhere((e) {
                                  return e['uid'] == order[index];
                                })['username']
                                .toString()
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                  itemCount: order.length,
                );
              });
        });
  }
}

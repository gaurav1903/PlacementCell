import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placement_cell/widgets/InputForm.dart';
import 'dart:developer';
import '../widgets/MessageBubble.dart';
import 'package:placement_cell/userdata.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('dashboard').snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            var z = snap.data as QuerySnapshot<Map<String, dynamic>>;
            log(z.docs.length.toString());
            return Container(
              color: Colors.green.shade200,
              child: Stack(children: [
                ListView.builder(
                    itemBuilder: (ctx, index) {
                      return MessageBubble(z.docs[index]['text'].toString(),
                          z.docs[index]['url'], z.docs[index]['username']);
                    },
                    itemCount: z.docs.length),
                if (User.mode != Mode.Student)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                title: Text('Write Post'),
                                content: InputForm(),
                              );
                            });
                      },
                      child: Icon(Icons.add),
                    ),
                  )
              ]),
            );
          }
        });
  }
}

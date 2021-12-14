import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placement_cell/widgets/InputForm.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('dashboard')
            .orderBy('time', descending: true)
            .limit(20)
            .snapshots(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            var z = snap.data as QuerySnapshot<Map<String, dynamic>>;
            return Stack(children: [
              ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Message(z.docs[index]['text']);
                  },
                  itemCount: z.docs.length),
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
            ]);
          }
        });
  }
}

class Message extends StatelessWidget {
  String text;
  Message(this.text);
  @override
  Widget build(BuildContext context) {
    return Card(child: Text(text));
  }
}

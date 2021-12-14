import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InputForm extends StatefulWidget {
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var PickedImage;
  var text;
  void submit() {
    k.currentState?.save();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('dashboard').add({});
  }

  final k = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Center(
        child: Form(
          key: k,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final imagefile = await ImagePicker.platform
                        .getImage(source: ImageSource.gallery);
                    setState(() {
                      if (imagefile != null) PickedImage = imagefile;
                    });
                  },
                  child: CircleAvatar(
                      minRadius: 40,
                      child: Icon(Icons.image),
                      backgroundImage: PickedImage == null
                          ? null
                          : FileImage(File((PickedImage as XFile).path))),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Write Post'),
                  onChanged: (val) {
                    text = val;
                  },
                ),
                TextButton(child: Text('Submit'), onPressed: submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

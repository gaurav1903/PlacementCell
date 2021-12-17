import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'package:placement_cell/userdata.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InputForm extends StatefulWidget {
  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var PickedImage;
  var text = "";
  var isloading = false;
  Future<void> submit() async {
    k.currentState?.save();
    FocusScope.of(context).unfocus();
    log("starting to submit");
    if (PickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref('Dashboard')
          .child(Timestamp.now().toString() + '.jpg');
      log("checkpoint 1");
      await ref.putFile(File((PickedImage as XFile).path)).then((p) async {
        log("checkpoint 2");
        String url = await ref.getDownloadURL();
        log(url.toString());
        FirebaseFirestore.instance.collection('dashboard').add({
          'user': User().uid,
          'url': url,
          'text': text,
          'username': User().getname()
        });
      });
    } else {
      FirebaseFirestore.instance.collection('dashboard').add({
        'user': User().uid,
        'url': '',
        'text': text,
        'username': User().getname()
      });
    }
    setState(() {
      isloading = false;
    });
    Navigator.of(context).pop();
  }

  final k = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (isloading == false)
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
                  TextButton(
                      child: Text('Submit'),
                      onPressed: () {
                        setState(() {
                          isloading = true;
                          submit();
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    else
      return Center(child: CircularProgressIndicator());
  }
}

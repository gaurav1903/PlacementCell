import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/userdata.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'dart:io';

class OfficialProfileScreen extends StatefulWidget {
  const OfficialProfileScreen({Key? key}) : super(key: key);

  @override
  State<OfficialProfileScreen> createState() => _OfficialProfileScreenState();
}

class _OfficialProfileScreenState extends State<OfficialProfileScreen> {
  var PickedImage;
  bool isloading = false;
  String bio = "";
  String company = "";
  Future<void> _submit() async {
    String imageurl = "";

    key.currentState?.validate();
    key.currentState?.save();
    final ref1 = FirebaseStorage.instance
        .ref("User")
        .child(User().uid)
        .child(" pic.jpg");
    if (PickedImage != null)
      await ref1
          .putFile(File((PickedImage as XFile).path))
          .then((imageresult) async {
        imageurl = await ref1.getDownloadURL();
      });
    FirebaseFirestore.instance.collection("users").doc(User.userid).update({
      "imageurl": imageurl,
      'bio': bio,
      'company': company
    }); //TODO::add this in company list too
    setState(() {
      isloading = false;
    });
  }

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    log(User.mode.toString() + "       mode");
    return (isloading == true)
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    child: PickedImage == null
                        ? User.imageurl != null &&
                                User.imageurl.toString().isNotEmpty
                            ? Image.network(User.imageurl)
                            : Image.asset('assets/selectImage.jpg',
                                fit: BoxFit.fitWidth)
                        : Image.file(File((PickedImage as XFile).path),
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth),
                    onTap: () {
                      ImagePicker.platform
                          .getImage(source: ImageSource.gallery)
                          .then((value) {
                        setState(() {
                          PickedImage = value;
                        });
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: key,
                    child: Column(children: [
                      Text('BIO'),
                      TextFormField(
                        initialValue: User.bio,
                        maxLines: 20,
                        minLines: 1,
                        decoration: InputDecoration(helperText: "BIO"),
                      ),
                      SizedBox(height: 50),
                      User.mode == Mode.Recruiter
                          ? Text("Company")
                          : Text("College Name"),
                      TextFormField(
                        maxLines: 1,
                        initialValue: User.company == null
                            ? null
                            : User.company.toString(),
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return "Can't be Empty";
                          return null;
                        },
                        onSaved: (val) {
                          company = val.toString();
                        },
                        decoration: InputDecoration(
                            helperText: User.mode == Mode.Recruiter
                                ? "Company"
                                : "College Name"),
                      )
                    ]),
                  ),
                ),
                TextButton(
                    child: Text("Submit"),
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      _submit();
                    })
              ],
            ),
          );
  }
}
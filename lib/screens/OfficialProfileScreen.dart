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
  var bio = User.bio == null ? "" : User.bio;
  var company = User.company == null ? "" : User.company;
  String imageurl = User.imageurl == null ? "" : User.imageurl;
  Future<void> _submit() async {
    log("submit running in officialprofilescreen");
    log(bio.toString());
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
    await FirebaseFirestore.instance
        .collection("users")
        .doc(User.userid)
        .update({"imageurl": imageurl, 'bio': bio, 'company': company});
    //TODO::add this in company list too
    User.bio = bio;
    User.company = company;
    setState(() {
      isloading = false;
    });
    const snackbar = SnackBar(
      content: const Text("Profile Saved"),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    log(company.toString());
    log(User.mode.toString() + "       mode");
    return (isloading == true)
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.green.shade100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 250,
                    margin: EdgeInsets.all(20),
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
                          onSaved: (val) {
                            bio = val.toString();
                          },
                        ),
                        SizedBox(height: 50),
                        User.mode == Mode.Recruiter
                            ? Text("Company")
                            : Text("College Name"),
                        TextFormField(
                          maxLines: 1,
                          initialValue:
                              company == null ? null : company.toString(),
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
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    child: Text("Submit"),
                    onPressed: () {
                      setState(() {
                        isloading = true;
                      });
                      _submit();
                    },
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          );
  }
}

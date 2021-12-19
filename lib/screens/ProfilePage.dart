import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  String url;
  ProfilePage(this.url);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var PickedImage;
  final k = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue.shade50,
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                child: PickedImage == null
                    ? Image.asset('assets/selectImage.jpg',
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
            SizedBox(height: 20),
            Form(
              key: k,
              child: Column(children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Field("Batch year", TextInputType.number),
                    SizedBox(width: 50),
                    Field(
                        "CGPA", TextInputType.numberWithOptions(decimal: true))
                  ],
                )
              ]),
            ),
          ],
        ));
  }
}

class Field extends StatelessWidget {
  String s;
  TextInputType t;
  Field(this.s, this.t);

  @override
  Widget build(BuildContext context) {
    // log(MediaQuery.of(context).size.width.toString());

    return Container(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(s),
          TextFormField(
            keyboardType: t,
            decoration: InputDecoration(helperText: "Enter " + s),
          )
        ],
      ),
    );
  }
}

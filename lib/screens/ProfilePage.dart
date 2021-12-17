import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            child: PickedImage == null
                ? Image.asset(
                    'assets/selectImage.jpg',
                  )
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
        )
      ],
    ));
  }
}

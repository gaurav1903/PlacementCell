import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  List skills = [];
  List domain = [];
  var skillval, domainval;
  Future<void> getting_data() async {
    await FirebaseFirestore.instance
        .collection('skills')
        .doc('l1G4TFS9carHqG25KrfJ')
        .get()
        .then((value) {
      skills = value.data()?['skills'].toList();
      skillval = skills[0];
    });
    await FirebaseFirestore.instance
        .collection('domain')
        .doc('h16ILMhCBNG96ItFqhzT')
        .get()
        .then((value) {
      domain = value.data()?['domain'].toList();
      domainval = domain[0];
    });
    return;
  }

  Future datafetching = Future.value();
  @override
  void initState() {
    datafetching = getting_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: datafetching,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
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
                          Field("CGPA",
                              TextInputType.numberWithOptions(decimal: true))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          DropdownButton(
                            value: skillval,
                            onChanged: (val) {
                              setState(() {
                                skillval = val;
                              });
                            },
                            items: skills.map((e) {
                              return DropdownMenuItem(
                                child: Text(e.toString()),
                                value: e.toString(),
                              );
                            }).toList(),
                          ),
                          DropdownButton(
                            items: [],
                            onChanged: null,
                          )
                        ],
                      )
                    ]),
                  ),
                ],
              ));
        });
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

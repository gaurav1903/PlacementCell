// import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePage extends StatefulWidget {
  String url;
  ProfilePage(this.url);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var PickedImage;
  var resume;
  final k = GlobalKey<FormState>();
  List skills = [];
  List domain = [];
  var skill1 = "Choose 1st skill", domainval = "Choose Domain";
  var skill2 = "Choose 2nd skill",
      skill3 = "Choose 3rd skill",
      skill4 = "Choose 4th skill",
      skill5 = "Choose 5th skill";
  Future<void> getting_data() async {
    await FirebaseFirestore.instance
        .collection('skills')
        .doc('l1G4TFS9carHqG25KrfJ')
        .get()
        .then((value) {
      skills = value.data()?['skills'].toList();
    });
    await FirebaseFirestore.instance
        .collection('domain')
        .doc('h16ILMhCBNG96ItFqhzT')
        .get()
        .then((value) {
      domain = value.data()?['domain'].toList();
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
          // skills = allskills;
          // log(skills.toString());
          log(domain.toString());
          // log(allskills.toString());
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          return SingleChildScrollView(
            child: Container(
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
                    const SizedBox(height: 20),
                    Form(
                      key: k,
                      child: Column(children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Field("Batch year", TextInputType.number),
                            const SizedBox(width: 50),
                            Field(
                                "CGPA",
                                const TextInputType.numberWithOptions(
                                    decimal: true))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Choose 5 Skills",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton(
                            key: const ValueKey("1st skill"),
                            value: skill1,
                            onChanged: (val) {
                              setState(() {
                                skill1 = val.toString().toLowerCase();
                              });
                            },
                            items: [
                                  const DropdownMenuItem(
                                    child: Text("Choose 1st skill"),
                                    value: "Choose 1st skill",
                                  )
                                ] +
                                skills.where((element) {
                                  var z = element.toString().toLowerCase();
                                  return (z != skill2 &&
                                      z != skill3 &&
                                      z != skill4 &&
                                      z != skill5);
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.toString().toLowerCase()),
                                    value: e.toString().toLowerCase(),
                                  );
                                }).toList()),
                        DropdownButton(
                            key: const ValueKey("skill 2"),
                            value: skill2,
                            onChanged: (val) {
                              setState(() {
                                skill2 = val.toString().toLowerCase();
                              });
                            },
                            items: [
                                  const DropdownMenuItem(
                                    child: Text("Choose 2nd skill"),
                                    value: "Choose 2nd skill",
                                  )
                                ] +
                                skills.where((element) {
                                  var z = element.toString().toLowerCase();
                                  return (z != skill1 &&
                                      z != skill3 &&
                                      z != skill4 &&
                                      z != skill5);
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.toString().toLowerCase()),
                                    value: e.toString().toLowerCase(),
                                  );
                                }).toList()),
                        DropdownButton(
                            key: const ValueKey("skill 3"),
                            value: skill3,
                            onChanged: (val) {
                              setState(() {
                                skill3 = val.toString().toLowerCase();
                              });
                            },
                            items: [
                                  DropdownMenuItem(
                                    child: Text("Choose 3rd skill"),
                                    value: "Choose 3rd skill",
                                  )
                                ] +
                                skills.where((element) {
                                  var z = element.toString().toLowerCase();
                                  return (z != skill1 &&
                                      z != skill2 &&
                                      z != skill4 &&
                                      z != skill5);
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.toString().toLowerCase()),
                                    value: e.toString().toLowerCase(),
                                  );
                                }).toList()),
                        DropdownButton(
                            key: ValueKey("skill 4"),
                            value: skill4,
                            onChanged: (val) {
                              setState(() {
                                skill4 = val.toString().toLowerCase();
                              });
                            },
                            items: [
                                  DropdownMenuItem(
                                    child: Text("Choose 4th skill"),
                                    value: "Choose 4th skill",
                                  )
                                ] +
                                skills.where((element) {
                                  var z = element.toString().toLowerCase();
                                  return (z != skill1 &&
                                      z != skill2 &&
                                      z != skill3 &&
                                      z != skill5);
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.toString().toLowerCase()),
                                    value: e.toString().toLowerCase(),
                                  );
                                }).toList()),
                        DropdownButton(
                            key: ValueKey("skill 5"),
                            value: skill5,
                            onChanged: (val) {
                              setState(() {
                                skill5 = val.toString().toLowerCase();
                              });
                            },
                            items: [
                                  DropdownMenuItem(
                                    child: Text("Choose 5th skill"),
                                    value: "Choose 5th skill",
                                  )
                                ] +
                                skills.where((element) {
                                  var z = element.toString().toLowerCase();
                                  return (z != skill1 &&
                                      z != skill2 &&
                                      z != skill3 &&
                                      z != skill4);
                                }).map((e) {
                                  return DropdownMenuItem(
                                    child: Text(e.toString().toLowerCase()),
                                    value: e.toString().toLowerCase(),
                                  );
                                }).toList()),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DropdownButton(
                                value: domainval,
                                onChanged: (val) {
                                  setState(() {
                                    domainval = val.toString();
                                  });
                                },
                                items: [
                                      DropdownMenuItem(
                                          child: Text("Choose Domain"),
                                          value: "Choose Domain")
                                    ] +
                                    domain.map((e) {
                                      return DropdownMenuItem(
                                        child: Text(e.toString()),
                                        value: e.toString(),
                                      );
                                    }).toList()),
                            SizedBox(width: 60),
                            OutlinedButton(
                                onPressed: () {
                                  FilePicker.platform.pickFiles(
                                      dialogTitle: "Choose Resume pdf",
                                      allowCompression: true,
                                      type: FileType.custom,
                                      allowedExtensions: ["pdf"]).then((value) {
                                    if (value != null)
                                      setState(() {
                                        resume = value;
                                      });
                                  });
                                },
                                child: resume == null
                                    ? Text("Add Resume")
                                    : Text("Change Resume")),
                            SizedBox(width: 10),
                            if (resume != null)
                              Icon(Icons.file_present)
                            else
                              Icon(Icons.upload_file_outlined)
                          ],
                        ), //domain and add resume
                        SizedBox(height: 10),
                        TextButton(onPressed: null, child: Text("Submit"))
                      ]),
                    ),
                  ],
                )),
          );
        });
  }
}

//TODO::ADD SUBMIT BUTTON AND RESUME AND DOMAIN AND ADD SEARCH FUNCTIONALITY
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

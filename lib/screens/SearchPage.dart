import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../widgets/full_userdata.dart' as Userdata;
import 'package:placement_cell/userdata.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var s = "Name";
  String field = "";
  var domainval = "Enter Domain";
  var skillval = "Choose Skill";
  double cgpa = 0;
  bool val = false;
  List data = Userdata.partialdata();
  final k = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  List domains = [], skills = [];
  void _submit() {
    var status = k.currentState;
    // FocusScope.of(context).unfocus();
    // log("status " + status.toString());
    final isvalid = status?.validate();
    if (isvalid == true && status != null) status.save();
  }

  Future getdata() async {
    await FirebaseFirestore.instance
        .collection('domain')
        .doc('h16ILMhCBNG96ItFqhzT')
        .get()
        .then((value) {
      domains = value.data()?['domain'].toList();
    });
    await FirebaseFirestore.instance
        .collection('skills')
        .doc('l1G4TFS9carHqG25KrfJ')
        .get()
        .then((value) {
      skills = value.data()?['skills'].toList();
    });
    return await FirebaseFirestore.instance.collection('users').get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdata(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          var x = snap.data as QuerySnapshot<Map<String, dynamic>>;
          List l = x.docs.toList();
          log("userdata" + Userdata.l.toString());
          if (Userdata.l.isEmpty) {
            Userdata.setl(l);
            data = l;
            Userdata.setpartialdata(l);
          }
          log("data" + data.toString());
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    'Search By',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  DropdownButton(
                      iconEnabledColor: Colors.grey,
                      iconDisabledColor: Colors.black,
                      value: s,
                      onChanged: (s1) {
                        s = s1.toString();
                        setState(() {
                          data = l;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text("Name"),
                          value: "Name",
                          onTap: () {
                            setState(() {
                              s = "Name";
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text("Skills"),
                          value: "Skills",
                          onTap: () {
                            setState(() {
                              s = "Skills";
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text("Domain"),
                          value: "Domain",
                          onTap: () {
                            setState(() {
                              s = "Domain";
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text("CGPA"),
                          value: "CGPA",
                          onTap: () {
                            setState(() {
                              s = "CGPA";
                            });
                          },
                        )
                      ]),
                  SizedBox(width: 30),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Open Source",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Switch(
                            value: val,
                            onChanged: (b) {
                              setState(() {
                                val = !val;
                              });
                            })
                      ])
                ]),
                if (s == "Name" || s == "CGPA")
                  Row(children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width - 150,
                      child: Form(
                        key: k,
                        child: s == "Name"
                            ? TextFormField(
                                // autofocus: true,
                                decoration:
                                    InputDecoration(helperText: 'Enter Name'),
                                onSaved: (val) {
                                  log("name runn" + val.toString());
                                  if (val != null) field = val;
                                  setState(() {
                                    data = l.where((element) {
                                      if ((element['username'] as String)
                                          .toLowerCase()
                                          .startsWith(field.toLowerCase()))
                                        return true;
                                      else
                                        return false;
                                    }).toList();
                                    Userdata.setpartialdata(data);
                                    log(data.length.toString());
                                  });
                                },
                              )
                            : TextFormField(
                                // autofocus: true,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: InputDecoration(
                                    helperText: 'Enter Cutoff Cgpa'),
                                validator: (val) {
                                  if (val == null) return "enter cgpa";
                                  double z;
                                  try {
                                    z = double.parse(val.toString());
                                  } catch (e) {
                                    return "enter a valid value";
                                  }
                                  if (z > 10 || z < 0 || val.isEmpty)
                                    return "Enter valid values";
                                  else
                                    return null;
                                },
                                onSaved: (val) {
                                  double v;
                                  if (val == null)
                                    v = 0;
                                  else
                                    v = double.parse(val);
                                  cgpa = v;
                                  setState(() {
                                    log("cgpa " + cgpa.toString());
                                    data = l.where((element) {
                                      if (element['CGPA'] >= cgpa) {
                                        log(element['username']);
                                        return true;
                                      } else
                                        return false;
                                    }).toList();
                                    Userdata.setpartialdata(data);
                                    log(data.length.toString());
                                  });
                                },
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(onPressed: _submit, child: Text('submit'))
                  ]),
                if (s == "Domain")
                  DropdownButton(
                    value: domainval,
                    items: [
                          DropdownMenuItem(
                              child: Text("Enter Domain"),
                              value: "Enter Domain")
                        ] +
                        domains.map((e) {
                          return DropdownMenuItem(
                              child: Text(e.toString()), value: e.toString());
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        domainval = val.toString();
                        //TODO::CHANGE DATA AND USERDATA'S PARTIAL
                        data = l.where((element) {
                          if (element['domain'] == domainval) {
                            return true;
                          } else
                            return false;
                        }).toList();
                        Userdata.setpartialdata(data);
                      });
                    },
                  ),
                if (s == "Skills")
                  DropdownButton(
                      value: skillval,
                      onChanged: (val) {
                        setState(() {
                          //TODO::CHANGE STUFF
                          skillval = val.toString();
                          data = l.where((element) {
                            log(element['skills'].toString());
                            if ((element['skills'] as List)
                                .contains(skillval)) {
                              return true;
                            } else
                              return false;
                          }).toList();
                          log(data.toString() +
                              " after data on basis of skill");
                          Userdata.setpartialdata(data);
                        });
                      },
                      items: skills.map((e) {
                            return DropdownMenuItem(
                                child: Text(e.toString()), value: e.toString());
                          }).toList() +
                          [
                            DropdownMenuItem(
                                child: Text("Choose Skill"),
                                value: "Choose Skill")
                          ]),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      log("rebuilt " + data.length.toString());
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('singleuser');
                            },
                            child: ListTile(
                              trailing: Card(
                                  color: Colors.grey.shade300,
                                  child: Text(
                                    data[index]['role'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )),
                              tileColor: Colors.grey.shade300,
                              leading: CircleAvatar(
                                child: (data[index]['imageurl'] as String)
                                        .isEmpty
                                    ? Icon(Icons.person)
                                    : ClipRRect(
                                        child: Image.network(
                                            data[index]['imageurl']),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                              ),
                              title: Text(data[index]['username']
                                  .toString()
                                  .toUpperCase()),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          )
                        ],
                      );
                    },
                    itemCount: data.length,
                  ),
                )
              ],
            ),
          );
        });
  }
}
//TODO::IMAGEURL MAKE A MANDATORY FIELD OR FIX IT HERE
//TODO:: FIX CIRCULAR AVATAR IMAGE
//TODO:: ADD  REMAINING SEARCH FILTERS

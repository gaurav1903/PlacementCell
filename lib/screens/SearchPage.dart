import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../widgets/full_userdata.dart' as userdata;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var s = "Name";
  String field = "";
  double cgpa = 0;
  bool val = false;
  List data = [];
  final k = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  void _submit() {
    var status = k.currentState;
    FocusScope.of(context).unfocus();
    // log("status " + status.toString());
    final isvalid = status?.validate();
    if (isvalid == true && status != null) status.save();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          var x = snap.data as QuerySnapshot<Map<String, dynamic>>;
          List l = x.docs.toList();
          log("userdata" + userdata.l.toString());
          if (userdata.l.isEmpty) {
            userdata.setl(l);
            data = l;
          }
          log("data" + data.toString());
          // log(l[0]['username']);
          // log(data.toString());
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
                                decoration:
                                    InputDecoration(helperText: 'Enter Name'),
                                onSaved: (val) {
                                  if (val != null) field = val;
                                  setState(() {
                                    data = l.where((element) {
                                      if ((element['username'] as String)
                                          .startsWith(field))
                                        return true;
                                      else
                                        return false;
                                    }).toList();
                                  });
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return "enter name";
                                  else
                                    return null;
                                },
                              )
                            : TextFormField(
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
                //TODO::
                // if (s == "Domain")
                //   DropdownButton(items: [])
                // else
                //   DropdownButton(items: []),
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
                              tileColor: Colors.grey.shade300,
                              leading: CircleAvatar(
                                child: (data[index]['url'] as String).isEmpty
                                    ? Icon(Icons.person)
                                    : Image.network(data[index]['url']),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:placement_cell/userdata.dart';
import '../widgets/full_userdata.dart ' as Users;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  Future f = Future.value();
  Future<void> func() async {
    if (Users.l.isEmpty)
      await FirebaseFirestore.instance
          .collection("users")
          .where("role", isNotEqualTo: "Student")
          .get()
          .then((val) {
        var z = val.docs;
        List temp = [];
        z.forEach((element) {
          if ((element.data() as Map<String, dynamic>).containsKey("company"))
            temp.add(element.data());
        });
        log("l changed hhere" + temp.toString());
        Users.setl(temp);
        Users.setpartialdata(temp);
      });
    if (Users.companies.isEmpty)
      await FirebaseFirestore.instance
          .collection("companies")
          .doc("VDvuRfstvofStGSeVVhZ")
          .get()
          .then((value) {
        Users.setcompanies(value.data()?['allcompanies']);
      });

    return;
  }

  @override
  void initState() {
    f = func();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: f,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.done)
            return UserSearchWidget();
          else
            return Center(child: CircularProgressIndicator());
        });
  }
}

class UserSearchWidget extends StatefulWidget {
  const UserSearchWidget({Key? key}) : super(key: key);

  @override
  _UserSearchWidgetState createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> {
  List data = Users.l;
  String value = "Choose Company";
  @override
  Widget build(BuildContext context) {
    log(data.length.toString() + "data len");
    return Container(
        child: Column(
      children: [
        DropdownButton(
            value: value,
            onChanged: (val) {
              setState(() {
                value = val.toString();
                if (val == "Choose Company")
                  data = Users.l;
                else
                  data = Users.l.where((element) {
                    return element['company'].toString().toLowerCase() ==
                        val.toString().toLowerCase();
                  }).toList();
              });
            },
            items: Users.companies.map((e) {
                  return DropdownMenuItem(
                    child: Text(e.toString()),
                    value: e.toString(),
                  );
                }).toList() +
                [
                  DropdownMenuItem(
                    child: Text("Choose Company"),
                    value: "Choose Company",
                  )
                ]),
        ListView.builder(
          itemBuilder: (context, index) {
            // log("rebuilt " + data.length.toString());
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('singleuser', arguments: data[index]);
                  },
                  child: ListTile(
                    trailing: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('message_screen',
                              arguments: data[index]);
                        },
                        child: Icon(Icons.message)),
                    tileColor: Colors.grey.shade300,
                    leading: CircleAvatar(
                      child: (data[index]['imageurl'] == null ||
                              data[index]['imageurl'].toString().isEmpty)
                          ? Icon(Icons.person)
                          : ClipRRect(
                              child: Image.network(data[index]['imageurl']),
                              borderRadius: BorderRadius.circular(20),
                            ),
                    ),
                    title:
                        Text(data[index]['username'].toString().toUpperCase()),
                  ),
                ),
                SizedBox(
                  height: 2,
                )
              ],
            );
          },
          shrinkWrap: true,
          itemCount: data.length,
        ),
      ],
    ));
  }
}
//TODO::ADD MODE VISE SEARCHING

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/full_userdata.dart ' as Users;

class UserSearchPage extends StatelessWidget {
  const UserSearchPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Users.l.isEmpty
        ? FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .get()
                .then((val) {
              var z = val.docs;
              List temp = [];
              z.forEach((element) {
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("batch")) temp.add(element.data());
              });
              Users.setl(temp);
              Users.setpartialdata(temp);
            }),
            builder: (ctx, snap) {
              if (snap.connectionState != ConnectionState.done)
                return Center(child: CircularProgressIndicator());
              else
                return Users.companies.isNotEmpty
                    ? UserSearchWidget()
                    : FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("companies")
                            .doc("VDvuRfstvofStGSeVVhZ")
                            .get()
                            .then((value) {
                          Users.setcompanies(value.data()?['allcompanies']);
                        }),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.done)
                            return UserSearchWidget();
                          else
                            return Center(child: CircularProgressIndicator());
                        });
            })
        : Users.companies.isNotEmpty
            ? UserSearchWidget()
            : FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("companies")
                    .doc("VDvuRfstvofStGSeVVhZ")
                    .get()
                    .then((value) {
                  Users.setcompanies(value.data()?['allcompanies']);
                }),
                builder: (context, snap) {
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
  @override
  Widget build(BuildContext context) {
    List data = Users.l;

    String value = "Choose Company";
    return Container(
        child: Column(
      children: [
        DropdownButton(
            value: value,
            onChanged: (val) {
              setState(() {
                value = val.toString();
                data = Users.l.where((element) {
                  return element['company'] == val;
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
                    Navigator.of(context).pushNamed('singleuser');
                  },
                  child: ListTile(
                    trailing: GestureDetector(
                        onTap: () {
                          //TODO::SET THIS
                          Navigator.of(context).pushNamed('message_screen',
                              arguments: data[index]);
                        },
                        child: Icon(Icons.message)),
                    tileColor: Colors.grey.shade300,
                    leading: CircleAvatar(
                      child: (data[index]['imageurl'] as String).isEmpty
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
          itemCount: data.length,
        ),
      ],
    ));
  }
}

import 'package:flutter/material.dart';

import 'dart:developer';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../widgets/PdfView.dart';

class SingleUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    log(user.toString() + "usr on single user page");
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        // margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5),
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    minRadius: 70,
                    maxRadius: 70,
                    backgroundImage: user == null || user['imageurl'] == null
                        ? AssetImage('assets/selectImage.jpg') as ImageProvider
                        : NetworkImage(
                            (user as Map<String, dynamic>)['imageurl']
                                .toString()),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  user['username'].toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 20),
            if (user['bio'] != null && user['bio'].toString().isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['bio'],
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            if (user['role'] == "Recruiter" ||
                user['role'] == "Placement Officer")
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Works at ",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        user['company'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " as ",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      Text(
                        user['role'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            if (user['role'] == 'Student')
              Column(
                children: [
                  Row(children: [
                    Text(
                      " Student ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "at",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Jamia Millia Islamia",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Batch:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text(user['batch'].toString(),
                                style: TextStyle(fontSize: 15))
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("CGPA:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Text(user['CGPA'].toString(),
                                style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ]),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Domain:",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 5),
                      Text(user['domain'], style: TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.height - 40,
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                              Container(
                                child: Text(
                                  "Skills : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ] +
                            (user['skills'] as List).map((e) {
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  // color: Colors.white,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(e));
                            }).toList()),
                  ),
                  SizedBox(height: 20),
                  if (user['resumeurl'] != null &&
                      user['resumeurl'].toString().isNotEmpty)
                    Column(
                      children: [
                        Text(
                          "Resume",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => Pdf(user['resumeurl'])));
                            },
                            icon: Icon(Icons.file_present))
                      ],
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

enum Mode { Student, PlacementOfficer, Recruiter }

class User {
  final z = FirebaseAuth.instance.currentUser;
  static final userid = FirebaseAuth.instance.currentUser?.uid;
  static var complete;
  static var username, batch, mode, domain;
  bool get completeness {
    return complete;
  }

  String get uid {
    if (userid == null)
      return "";
    else
      return userid.toString();
  }

  String getname() {
    return username;
  }

//TODO::SET ALL THE DATA HERE
  //CALL FROM HOMEPAGE AND FETCH ALL DATA AND THEN SET HERE
  void setdata(Map<String, dynamic> userdata) {
    complete = userdata['complete'];
    username = userdata['username'];
    batch = userdata['batch'];
    var temp = userdata['mode'];
    domain = userdata['domain'];
    // log("Data fetching is done" + username.toString());
    if (temp == 'Student')
      mode = Mode.Student;
    else if (temp == 'Recruiter')
      mode = Mode.Recruiter;
    else
      mode = Mode.PlacementOfficer;
  }

  Future<void> fetchdata() async {
    var uid = userid.toString();
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      var completedata = value.data();
      // log(completedata.toString());
      complete = completedata != null ? completedata['complete'] : '';
      // name = completedata != null ? completedata['name'] : '';
      username = completedata != null ? completedata['username'] : '';
      batch = completedata != null ? completedata['batch'] : '';
      var temp = completedata != null ? completedata['mode'] : Mode.Student;
      domain = completedata != null ? completedata['domain'] : "";
      // log("Data fetching is done" + username.toString());
      if (temp == 'Student')
        mode = Mode.Student;
      else if (temp == 'Recruiter')
        mode = Mode.Recruiter;
      else
        mode = Mode.PlacementOfficer;
    });
  }
}

String stringrole(String mode) {
  if (mode == Mode.PlacementOfficer)
    return "Placement Officer";
  else if (mode == Mode.Student)
    return "Student";
  else
    return "Recruiter";
}

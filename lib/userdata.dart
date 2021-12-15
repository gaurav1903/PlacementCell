import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Mode { Student, PlacementOfficer, Recruiter }

class User {
  final z = FirebaseAuth.instance.currentUser;
  static final userid = FirebaseAuth.instance.currentUser?.uid;
  static var complete;
  static var name = "", username, batch, mode;
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
    return name;
  }

  Future<void> fetchdata() async {
    var uid = userid.toString();
    FirebaseFirestore.instance.collection('user').doc(uid).get().then((value) {
      var completedata = value.data();
      complete = completedata != null ? completedata['complete'] : '';
      name = completedata != null ? completedata['name'] : '';
      username = completedata != null ? completedata['username'] : '';
      batch = completedata != null ? completedata['batch'] : '';
      var temp = completedata != null ? completedata['mode'] : Mode.Student;
      if (temp == 'Student')
        mode = Mode.Student;
      else if (temp == 'Recruiter')
        mode = Mode.Recruiter;
      else
        mode = Mode.PlacementOfficer;
    });
  }
}

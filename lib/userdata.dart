import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Mode { Student, PlacementOfficer, Recruiter }

class User {
  String userid = '';
  var complete;
  var name, username, batch, mode;
  bool get completeness {
    return complete;
  }

  String get uid {
    return userid;
  }

  void fetchdata(String uid) {
    userid = uid;
    FirebaseFirestore.instance.collection('user').doc(uid).get().then((value) {
      var completedata = value.data();
      complete = completedata?['complete'];
      name = completedata?['name'];
      username = completedata?['username'];
      batch = completedata?['batch'];
      var temp = completedata?['mode'];
      if (temp == 'Student')
        mode = Mode.Student;
      else if (temp == 'Recruiter')
        mode = Mode.Recruiter;
      else
        mode = Mode.PlacementOfficer;
    });
  }
}

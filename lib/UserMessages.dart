import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:placement_cell/userdata.dart';
import 'dart:developer';

class UserMessages with ChangeNotifier {
  List messages = [];
  void setmessages(List l) {
    log("set messages ran");
    messages = l;
    notifyListeners();
  }
}

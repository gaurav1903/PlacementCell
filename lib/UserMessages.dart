import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:placement_cell/userdata.dart';
import 'dart:developer';

import 'package:placement_cell/userdata.dart';

class UserMessages with ChangeNotifier {
  List messages = [];
  List recvmsgs = [];
  List sentmsgs = [];

  void setrecvmsgs(List x) {
    recvmsgs = x;
    setmessages(recvmsgs, sentmsgs);
  }

  void setsentmsgs(List y) {
    sentmsgs = y;
    setmessages(recvmsgs, sentmsgs);
  }

  void setmessages(List recvmsgs, List sentmsgs) {
    //use merging of 2 lists recvmsgs and sentmsgs
    log("set messages ran");
    messages = (recvmsgs + sentmsgs)
      ..sort((a, b) {
        if (a['time'].toString().compareTo(b['time'].toString()) < 0) return 0;
        return 1;
      }); //returns true means a can be put before b

    notifyListeners();
  }
}

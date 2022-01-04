import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

List l = []; //all users//is a list of queerysnapshots
List partial = []; //same for this
void setl(List data) {
  l = data;
}

List get data {
  return l;
}

void setpartialdata(List x) {
  partial = x;
}

List partialdata() {
  return partial;
}

List skills = [];
List domains = [];
//TODO::STORE SKILLS AND DOMAIN HERE AND STOP FETCHING AGAIN AND AGAIN

List messages = [];

//TODO::SHOULD RUN EACH TIME A NEW MESSAGE COMES
class AllMessagesdownloaded with ChangeNotifier {
  void setmessages(List m) //it should run each time a new message is recieved
  {
    messages = m;
    notifyListeners();
  }
}

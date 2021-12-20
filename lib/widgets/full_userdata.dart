import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List l = [];
List partial = [];
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

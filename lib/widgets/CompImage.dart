import 'package:flutter/material.dart';

class CompleteImage extends StatelessWidget {
  String url;
  var type;
  CompleteImage(this.url, this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
            child: type == 'network' ? Image.network(url) : Image.asset(url)));
  }
}

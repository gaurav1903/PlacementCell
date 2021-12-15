import 'package:flutter/material.dart';

class CompleteImage extends StatelessWidget {
  String url;
  CompleteImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(child: Expanded(child: Image.network(url)));
  }
}

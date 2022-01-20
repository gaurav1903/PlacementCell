import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:placement_cell/widgets/CompImage.dart';

class MessageBubble extends StatelessWidget {
  String msg, url, username;
  MessageBubble(this.msg, this.url, this.username);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                ),
                width: 300,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(msg, style: TextStyle(color: Colors.black)))
          ],
        ),
        SizedBox(height: 10),
        if (url != "")
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return CompleteImage(url, 'network');
              }));
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Container(
                    width: 300,
                    // padding: EdgeInsets.all(10),
                    // margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage(
                          placeholder: AssetImage(
                            'assets/loading.jpg',
                          ),
                          image: NetworkImage(url)),
                    ))),
          ),
        SizedBox(height: 10)
      ],
    );
  }
}

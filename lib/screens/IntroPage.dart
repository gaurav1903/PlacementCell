import 'package:flutter/material.dart';
import 'package:placement_cell/widgets/CompImage.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Image.asset('assets/jmi.png'),
        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return CompleteImage('assets/jmi-front.jpg', "asset");
              }));
            },
            child: Image.asset('assets/jmi-front.jpg')),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Text(
              "The Department of Computer Engineering (DCoE) incessantly endeavours to impart quality education that prepares its students for an excelling career in industry and academia.",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "One of the foremost departments of the Faculty of Engineering and Technology, DCoE’s robust industry connect and reputation ensure it records the highest placement ratio among all the departments, year after year",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Some of our undergraduate students have gone on grace the admission records of some of the top ranked universities of the world.",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 5),
            Text(
                "Our Vision is to produce excellent professionals and innovators in the field of Computer Engineering for the economic development and global competitiveness of the nation.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
          ]),
        ),
      ],
    ));
  }
}

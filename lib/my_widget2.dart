import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyWidget2 extends StatelessWidget {
  MyWidget2();

  factory MyWidget2.forDesignTime() {
    return new MyWidget2();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text('A'),
        new Text('BB'),
        new Text('CCC'),
        Image.network(
            "https://www.google.com.tw/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"),
        SizedBox(
          height: 20.0,
          child: Container(
            decoration: BoxDecoration(color: Colors.red),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
              ),
            ),
          ],
        )
      ],
    );
  }
}

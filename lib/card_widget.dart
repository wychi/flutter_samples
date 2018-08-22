import 'package:flutter/material.dart';
import 'package:flutter_app/styles.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onMenuClicked;

  CardWidget({this.child, this.onMenuClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B224E),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Stack(
          children: <Widget>[
            child,
            buildMenu(),
          ],
        ),
      ),
    );
  }

  Positioned buildMenu() {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 44.0,
        height: 44.0,
        child: IconButton(
          key: Key("menu"),
          onPressed: onMenuClicked,
          icon: Icon(Icons.more_vert),
          color: Styles.cnm_white,
        ),
      ),
    );
  }
}

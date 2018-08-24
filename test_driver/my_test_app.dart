import 'package:flutter/material.dart';

class MyTestApp extends StatelessWidget {
  final Widget child;
  final WidgetBuilder builder;

  MyTestApp({this.child, this.builder});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MyTestApp',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: child ?? builder(context),
      ),
    );
  }
}

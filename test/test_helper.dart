import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_http_client.dart';

WidgetTesterCallback mockTester(WidgetTesterCallback callback) {
  return (WidgetTester tester) async {
    await HttpOverrides.runZoned(() async {
      callback(tester);
    }, createHttpClient: createMockImageHttpClient);
  };
}

Widget wrap(Widget widget) {
  return MaterialApp(
    title: 'Flutter Demo',
    theme: new ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: Scaffold(
      body: RepaintBoundary(
        key: Key("golden"),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 360.0),
            child: widget,
          ),
        ),
      ),
    ),
  );
}

class MockCallbackHandler extends Mock {
  VoidCallback get onClicked;
}

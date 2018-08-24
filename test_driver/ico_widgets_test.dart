import 'dart:async';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

Future<Null> capture(FlutterDriver driver, String filename) async {
  final File file = new File(filename);
  if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
  await driver.screenshot().then((data) {
    return file.writeAsBytes(data);
  });
}

void main() {
  int WIDTH = 0;
  int HEIGHT = 0;
  String getFileName(String name) {
    String screenSize = "${WIDTH}x$HEIGHT";
    return "test_driver/screenshots/$screenSize/$name.png";
  }

  group('ico_widget_display', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
      var renderTree = (await driver.getRenderTree()).tree;

      const windowSizePattern = "window size: Size(";
      var idx = renderTree.indexOf(windowSizePattern);
      var endIdx = renderTree.indexOf(")", idx);
      List<String> windowSize = renderTree
          .substring(idx + windowSizePattern.length, endIdx)
          .split(",");
      WIDTH = double.parse(windowSize[0]).toInt();
      HEIGHT = double.parse(windowSize[1]).toInt();
    });

    tearDownAll(() async {
      await driver?.close();
    });

    test('render', () async {
      await capture(driver, getFileName("ico_widget_list"));
    });
  });
}

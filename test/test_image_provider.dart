import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class TestImageProvider extends ImageProvider<TestImageProvider> {
  TestImageProvider(this.testImage);

  final ui.Image testImage;

  final Completer<ImageInfo> _completer = new Completer<ImageInfo>.sync();
  ImageConfiguration configuration;

  @override
  Future<TestImageProvider> obtainKey(ImageConfiguration configuration) {
    return new SynchronousFuture<TestImageProvider>(this);
  }

  @override
  ImageStream resolve(ImageConfiguration config) {
    configuration = config;
    return super.resolve(configuration);
  }

  @override
  ImageStreamCompleter load(TestImageProvider key) =>
      new OneFrameImageStreamCompleter(_completer.future);

  ImageInfo complete() {
    final ImageInfo imageInfo = new ImageInfo(image: testImage);
    _completer.complete(imageInfo);
    return imageInfo;
  }

  @override
  String toString() => '${describeIdentity(this)}()';
}

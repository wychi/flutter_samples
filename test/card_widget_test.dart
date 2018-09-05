import 'package:flutter/material.dart';
import 'package:flutter_app/card_widget.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets('small', (WidgetTester tester) async {
    var clicked = false;
    await tester.pumpWidget(
      wrap(
        CardWidget(
            child: Container(
              height: 50.0,
            ),
            onMenuClicked: (_) {
              clicked = true;
            }),
      ),
    );

    await tester.tap(find.byKey(Key("menu")));
    expect(clicked, true);

    await expectLater(
      find.byType(CardWidget),
      matchesGoldenFile('golden/CardWidget.png'),
    );
  });
}

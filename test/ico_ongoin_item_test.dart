import 'package:flutter/material.dart';
import 'package:flutter_app/card_widget.dart';
import 'package:flutter_app/ico_ongoing_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  const ITEM = {
    "name": "Kimera",
    "symbol": "KIMERA",
    "category": "Business Services & Consulting",
    "score": "4.7"
  };

  testWidgets('IcoOngoingItem', mockTester((WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        IcoOngoingItem(),
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.add_alert), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("2"), findsOneWidget);
    expect(find.text(ITEM["name"]), findsOneWidget);
    expect(find.text(ITEM["symbol"]), findsOneWidget);
    expect(find.text(ITEM["category"]), findsOneWidget);
    expect(find.text(ITEM["score"]), findsOneWidget);

    await expectLater(
      find.byType(CardWidget),
      matchesGoldenFile('golden/IcoOngoingItem.png'),
    );
  }));
}

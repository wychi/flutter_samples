import 'package:flutter/material.dart';
import 'package:flutter_app/ico_ongoing_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  testWidgets('IcoOngoingItem', mockTester((WidgetTester tester) async {
    const int idx = 1;
    const ITEM = {
      "name": "Kimera",
      "symbol": "KIMERA",
      "category": "Business Services & Consulting",
      "score": "4.7"
    };

    await tester.pumpWidget(
      wrap(
        IcoOngoingItem.forTest(ITEM, idx),
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.add_alert), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("$idx"), findsOneWidget);
    expect(find.text(ITEM["name"]), findsOneWidget);
    expect(find.text(ITEM["symbol"]), findsOneWidget);
    expect(find.text(ITEM["category"]), findsOneWidget);
    expect(find.text(ITEM["score"]), findsOneWidget);

    await expectLater(
      find.byType(IcoOngoingItem),
      matchesGoldenFile('golden/IcoOngoingItem.png'),
    );
  }));

  testWidgets('layout_test', mockTester((WidgetTester tester) async {
    const int idx = 100;
    const ITEM = {
      "name": "KimeraKimeraKimeraKimera",
      "symbol": "KIMERAKIMERAKIMERA",
      "category": "Business Services & Consulting",
      "score": "4.7"
    };

    await tester.pumpWidget(
      wrap(
        IcoOngoingItem.forTest(ITEM, idx),
      ),
    );

    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.add_alert), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("$idx"), findsOneWidget);
    expect(find.text(ITEM["name"]), findsOneWidget);
    expect(find.text(ITEM["symbol"]), findsOneWidget);
    expect(find.text(ITEM["category"]), findsOneWidget);
    expect(find.text(ITEM["score"]), findsOneWidget);

    await expectLater(
      find.byType(IcoOngoingItem),
      matchesGoldenFile('golden/IcoOngoingItem_Long.png'),
    );
  }));
}

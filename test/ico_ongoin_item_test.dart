import 'package:flutter/material.dart';
import 'package:flutter_app/ico/ico_ongoing_item.dart';
import 'package:flutter_app/styles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

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

  testWidgets('state_test', mockTester((WidgetTester tester) async {
    const int idx = 100;
    var item = {
      "name": "KimeraKimeraKimeraKimera",
      "symbol": "KIMERAKIMERAKIMERA",
      "category": "Business Services & Consulting",
      "score": "4.7",
      "favorite_added": true,
      "alert_added": true,
    };

    await tester.pumpWidget(
      wrap(
        IcoOngoingItem.forTest(item, idx),
      ),
    );

    {
      expect(find.byIcon(Icons.star_border), findsOneWidget);
      final IconButton widget =
          tester.firstWidget(find.byKey(Key("add_favorite")));
      expect(widget.color, Styles.cnm_orange_300);
    }
    {
      expect(find.byIcon(Icons.add_alert), findsOneWidget);
      final IconButton widget =
          tester.firstWidget(find.byKey(Key("add_alert")));
      expect(widget.color, Styles.cnm_orange_300);
    }

    expect(find.byType(Image), findsOneWidget);
    expect(find.text("$idx"), findsOneWidget);
    expect(find.text(item["name"]), findsOneWidget);
    expect(find.text(item["symbol"]), findsOneWidget);
    expect(find.text(item["category"]), findsOneWidget);
    expect(find.text(item["score"]), findsOneWidget);

    await expectLater(
      find.byType(IcoOngoingItem),
      matchesGoldenFile('golden/IcoOngoingItem_State.png'),
    );
  }));

  testWidgets('click_test', mockTester((WidgetTester tester) async {
    var itemClickedHandler = new MockCallbackHandler();
    var alertClickedHandler = new MockCallbackHandler();
    var favoriteClickedHandler = new MockCallbackHandler();

    const int idx = 100;
    var item = {
      "name": "KimeraKimeraKimeraKimera",
      "symbol": "KIMERAKIMERAKIMERA",
      "category": "Business Services & Consulting",
      "score": "4.7",
      "favorite_added": true,
      "alert_added": true,
      "onItemClicked": () {
        itemClickedHandler.onClicked();
      },
      "onAlertClicked": () {
        alertClickedHandler.onClicked();
      },
      "onFavoriteClicked": () {
        favoriteClickedHandler.onClicked();
      }
    };

    await tester.pumpWidget(
      wrap(
        IcoOngoingItem.forTest(item, idx),
      ),
    );

    await tester.tap(find.byKey(Key("add_alert")));
    verify(alertClickedHandler.onClicked());

    await tester.tap(find.byKey(Key("add_favorite")));
    verify(favoriteClickedHandler.onClicked());

    await tester.tap(find.byType(IcoOngoingItem));
    verify(itemClickedHandler.onClicked());
  }));
}

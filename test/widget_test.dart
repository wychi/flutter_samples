// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_helper.dart';

void main() {
  group("basic", () {
    testWidgets('long text', mockTester((WidgetTester tester) async {
      var name = "Not Started Coin Not Started Coin";
      var symbol = "LNC";
      var stage = IcoStage.PreSale;
      var startTs = DateTime(2025, 5, 20).millisecondsSinceEpoch;

      var widget = wrap(
        IcoWatchListItem.sample(
          name: name,
          symbol: symbol,
          stage: stage,
          startTs: startTs,
        ),
      );

      await tester.pumpWidget(widget);

      expect(find.byType(Image), findsNWidgets(1));
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
      expect(find.text(name), findsOneWidget);
      expect(find.text(symbol), findsOneWidget);
      expect(find.text('Presale'), findsOneWidget);

      // expect(find.text('2025-05-20'), findsOneWidget);
      var hasDateText = find.byType(Text).evaluate().where((element) {
        var widget = element.widget;
        if (widget is Text) {
          return widget.data.contains("2025-05-20");
        }
        return false;
      }).isNotEmpty;
      expect(hasDateText, true);

      expect(find.text('opens in'), findsOneWidget);

      await expectLater(
        find.byKey(Key("golden")),
        matchesGoldenFile('golden/ico_watchlist_item_not_started.png'),
      );
    }));

    testWidgets('normal', mockTester((WidgetTester tester) async {
      var name = "My Very LongNameCoin";
      var symbol = "LNC";
      var stage = IcoStage.PreSale;
      var startTs = DateTime(2017, 5, 20).millisecondsSinceEpoch;

      var widget = wrap(
        IcoWatchListItem.sample(
          name: name,
          symbol: symbol,
          stage: stage,
          startTs: startTs,
        ),
      );

      await tester.pumpWidget(widget);

      // Verify that our counter starts at 0.
      expect(find.text(name), findsOneWidget);
      expect(find.text(symbol), findsOneWidget);
      expect(find.text('Presale'), findsOneWidget);
      expect(find.text('Opened'), findsOneWidget);

      await expectLater(
        find.byKey(Key("golden")),
        matchesGoldenFile('golden/ico_watchlist_item_started.png'),
      );
    }));

    testWidgets('tap_menu', mockTester((WidgetTester tester) async {
      var name = "My Very LongNameCoin";
      var symbol = "LNC";
      var stage = IcoStage.PreSale;
      var startTs = DateTime(2017, 5, 20).millisecondsSinceEpoch;

      var clickedHandler = new MockCallbackHandler();

      var widget = wrap(
        IcoWatchListItem.sample(
          name: name,
          symbol: symbol,
          stage: stage,
          startTs: startTs,
          onMenuClicked: clickedHandler.onClicked,
        ),
      );

      await tester.pumpWidget(widget);
      verify(clickedHandler.onClicked);
    }));
  }, tags: ["basic"]);
}

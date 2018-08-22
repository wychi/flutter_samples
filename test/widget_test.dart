// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_http_client.dart';

WidgetTesterCallback mockTester(WidgetTesterCallback callback) {
  return (WidgetTester tester) async {
    await HttpOverrides.runZoned(() async {
      callback(tester);
    }, createHttpClient: createMockImageHttpClient);
  };
}

Widget _wrap(Widget widget) {
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

void main() {
  testWidgets('small-NotStarted', mockTester((WidgetTester tester) async {
    var name = "Not Started Coin Not Started Coin";
    var symbol = "LNC";
    var stage = IcoStage.PreSale;
    var startTs = DateTime(2025, 5, 20).millisecondsSinceEpoch;

    var widget = _wrap(
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
  }));

  testWidgets('small-Started', mockTester((WidgetTester tester) async {
    var name = "My Very LongNameCoin";
    var symbol = "LNC";
    var stage = IcoStage.PreSale;
    var startTs = DateTime(2017, 5, 20).millisecondsSinceEpoch;

    var widget = _wrap(
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
  }));

  testWidgets('gold-NotStarted', mockTester((WidgetTester tester) async {
    var name = "Not Started Coin Not Started Coin";
    var symbol = "LNC";
    var stage = IcoStage.PreSale;
    var startTs = DateTime(2025, 5, 20).millisecondsSinceEpoch;

    var widget = _wrap(
      IcoWatchListItem.sample(
        name: name,
        symbol: symbol,
        stage: stage,
        startTs: startTs,
      ),
    );

    await tester.pumpWidget(widget);
    await expectLater(
      find.byKey(Key("golden")),
      matchesGoldenFile('golden/ico_watchlist_item_not_started.png'),
    );
  }));

  testWidgets('gold-Started', mockTester((WidgetTester tester) async {
    var name = "My Very LongNameCoin";
    var symbol = "LNC";
    var stage = IcoStage.PreSale;
    var startTs = DateTime(2017, 5, 20).millisecondsSinceEpoch;
    var widget = _wrap(
      IcoWatchListItem.sample(
        name: name,
        symbol: symbol,
        stage: stage,
        startTs: startTs,
      ),
    );

    await tester.pumpWidget(widget);
    await expectLater(
      find.byKey(Key("golden")),
      matchesGoldenFile('golden/ico_watchlist_item_started.png'),
    );
  }));
}
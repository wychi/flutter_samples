import 'package:flutter/material.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_app/ico_watchlist_page.dart';
import 'package:flutter_app/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'test_helper.dart';

class MockBloc extends Mock implements BloC {}

void main() {
  var kItems = new List<IcoItemViewModel>.generate(10, (idx) {
    var name = "$idx My Very LongNameCoin";
    var symbol = "$idx";
    var stage = "PreSale";
    var startTs =
        DateTime.now().add(Duration(days: idx * (idx.isEven ? -1 : 1)));

    var mapData = <String, dynamic>{
      "name": name,
      "symbol": symbol,
      "stage": stage,
      "startTs": startTs,
    };
    return new IcoItemViewModel(mapData);
  });

  testWidgets('layout-inflate', mockTester((WidgetTester tester) async {
    var mockBloc = new MockBloc();

    const itemCount = 10;
    IcoItemViewModel item = kItems[0];
    var c0 = new MockCallbackHandler();
    var menuClicker = new MockCallbackHandler();
    item.mapData['onItemClicked'] = c0.onClicked;
    item.mapData['onMenuClicked'] = menuClicker.onClicked;

    when(mockBloc.getItemCount()).thenReturn(itemCount);
//    when(mockBloc.getItem(0)).thenReturn(item0); // Note: not work in this way
    // Note: no way to get the value of arguments
    when(mockBloc.getItem(any)).thenReturn(item);

    await tester.pumpWidget(
      wrap(
        IcoWatchlistPage.forTest(mockBloc),
      ),
    );
    expect(find.byType(IcoWatchListItem), findsWidgets);
    expect(find.byKey(const ValueKey<int>(0)), findsOneWidget);
    expect(find.byKey(const ValueKey<int>(itemCount - 1)), findsNothing);

    // Note: the callCount will be reset after accessing
    var count = verify(mockBloc.getItem(any)).callCount;
    expect(count, lessThan(itemCount));

    await tester.tap(find.byKey(Key("menu")).first);
    verify(menuClicker.onClicked());

    await tester.tap(find.byKey(const ValueKey<int>(0)));
    verify(c0.onClicked());

    await tester.fling(
        find.byType(IcoWatchListItem).first, const Offset(0.0, -200.0), 5000.0);
    // Note: wait for fling animation
    await tester.pumpAndSettle();

    verify(mockBloc.getItem(any)).called(kItems.length - count);
  }));
}

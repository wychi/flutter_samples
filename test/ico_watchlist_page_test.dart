import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_app/ico_watchlist_page.dart';
import 'package:flutter_app/loading_widget.dart';
import 'package:flutter_app/models.dart';
import 'package:flutter_app/my_error_widget.dart';
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

    when(mockBloc.state).thenReturn(BlocState.DATA_READY);
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

  testWidgets('state-transition', mockTester((WidgetTester tester) async {
    const itemCount = 10;
    IcoItemViewModel item = kItems[0];
    var c0 = new MockCallbackHandler();
    var menuClicker = new MockCallbackHandler();
    item.mapData['onItemClicked'] = c0.onClicked;
    item.mapData['onMenuClicked'] = menuClicker.onClicked;

    var controller = new StreamController<BlocState>();

    var mockBloc = new MockBloc();
    when(mockBloc.state).thenReturn(BlocState.START);
    when(mockBloc.stream).thenAnswer((_) => controller.stream);
    verifyNever(mockBloc.getItemCount());
    verifyNever(mockBloc.getItem(any));

//    when(mockBloc.requestData()).thenAnswer((_) {
//      when(mockBloc.getItemCount()).thenReturn(itemCount);
//      when(mockBloc.getItem(any)).thenReturn(item);
//      when(mockBloc.state).thenReturn(BlocState.LOADING);
//      controller.add(mockBloc.state);
//    });

    {
      await tester.pumpWidget(
        wrap(
          IcoWatchlistPage.forTest(mockBloc),
        ),
      );

      expect(find.byType(IcoWatchListItem), findsNothing);
    }

    {
      when(mockBloc.state).thenReturn(BlocState.LOADING);
      controller.add(mockBloc.state);
      await tester.pumpAndSettle();

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(IcoWatchListItem), findsNothing);
    }
    {
      when(mockBloc.getItemCount()).thenReturn(itemCount);
      when(mockBloc.getItem(any)).thenReturn(item);
      when(mockBloc.state).thenReturn(BlocState.DATA_READY);
      controller.add(mockBloc.state);
      await tester.pumpAndSettle();

      expect(mockBloc.state, BlocState.DATA_READY);
      verify(mockBloc.getItemCount());
      verify(mockBloc.getItem(any));
      expect(find.byType(IcoWatchListItem), findsWidgets);
    }
    {
      when(mockBloc.state).thenReturn(BlocState.ERROR);
      controller.add(mockBloc.state);
      await tester.pumpAndSettle();

      expect(mockBloc.state, BlocState.ERROR);

      expect(find.byType(MyErrorWidget), findsOneWidget);
      expect(find.byType(IcoWatchListItem), findsNothing);
    }

    controller.close();
  }));
}

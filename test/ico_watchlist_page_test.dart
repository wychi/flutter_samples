import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ico/ico_bloc.dart';
import 'package:flutter_app/ico/ico_watchlist_item.dart';
import 'package:flutter_app/ico/ico_watchlist_page.dart';
import 'package:flutter_app/ico/models.dart';
import 'package:flutter_app/loading_widget.dart';
import 'package:flutter_app/my_error_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

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

    when(mockBloc.stateStream).thenAnswer((_) {
      return new PublishSubject<BlocState>().startWith(BlocState.DATA_READY);
    });
    when(mockBloc.state).thenReturn(null);
    when(mockBloc.getItemCount()).thenReturn(itemCount);
//    when(mockBloc.getItem(0)).thenReturn(item0); // Note: not work in this way
    // Note: no way to get the value of arguments
    when(mockBloc.getItem(any)).thenReturn(item);

    await tester.pumpWidget(
      wrap(
        IcoWatchlistPage.forTest(mockBloc),
      ),
    );
    // Note: if [StreamBuilder.initialData] is not set, we should pump one time.
    await tester.pump();

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

    print("start fling");
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

    final subject = new PublishSubject<BlocState>();
    subject.add(BlocState.START);

    var mockBloc = new MockBloc();
    verifyNever(mockBloc.getItemCount());
    verifyNever(mockBloc.getItem(any));

    when(mockBloc.stateStream).thenAnswer((_) {
      return subject;
    });

    {
      await tester.pumpWidget(
        wrap(
          IcoWatchlistPage.forTest(mockBloc),
        ),
      );

      expect(find.byType(IcoWatchListItem), findsNothing);
    }

    {
      scheduleMicrotask(() {
        subject.add(BlocState.LOADING);
      });

      //Note: [CircularProgressIndicator] will cause timeout
      //await tester.pumpAndSettle();
      await tester.pump();
      await tester.pump();

      expect(find.byType(LoadingWidget), findsOneWidget);
      expect(find.byType(IcoWatchListItem), findsNothing);
    }
    {
      when(mockBloc.getItemCount()).thenReturn(itemCount);
      when(mockBloc.getItem(any)).thenReturn(item);
      scheduleMicrotask(() {
        subject.add(BlocState.DATA_READY);
      });
      await tester.pumpAndSettle();

      verify(mockBloc.getItemCount());
      verify(mockBloc.getItem(any));
      expect(find.byType(IcoWatchListItem), findsWidgets);
    }
    {
      scheduleMicrotask(() {
        subject.add(BlocState.ERROR);
      });
      await tester.pumpAndSettle();

      expect(find.byType(MyErrorWidget), findsOneWidget);
      expect(find.byType(IcoWatchListItem), findsNothing);
    }

    subject.close();
  }));

  testWidgets('refresh', mockTester((WidgetTester tester) async {
    var itemCount = 10;
    var itemIdx = 0;

    var subject = new PublishSubject<BlocState>();
    var mockBloc = new MockBloc();
    {
      when(mockBloc.stateStream).thenAnswer((_) {
        return subject.startWith(BlocState.DATA_READY);
      });
      when(mockBloc.state).thenReturn(null);
      when(mockBloc.getItemCount()).thenReturn(itemCount);
      when(mockBloc.getItem(any)).thenReturn(kItems[itemIdx]);
    }

    {
      await tester.pumpWidget(wrap(IcoWatchlistPage.forTest(mockBloc)));
      await tester.pump();
      expect(find.byType(IcoWatchListItem), findsWidgets);
    }

    {
      itemCount = 1;
      itemIdx = 1;
      when(mockBloc.getItemCount()).thenReturn(itemCount);
      when(mockBloc.getItem(any)).thenReturn(kItems[itemIdx]);

      when(mockBloc.refresh()).thenAnswer((_) {
        subject.add(BlocState.DATA_READY);
        return Future.value(null);
      });

      await tester.drag(
        find.byType(IcoWatchListItem).first,
        const Offset(0.0, 200.0),
      );
      var frames = await tester.pumpAndSettle();
      print("frames=$frames");

      verify(mockBloc.refresh());
      expect(find.text("1"), findsWidgets);
      expect(find.byType(IcoWatchListItem), findsNWidgets(itemCount));
    }

    subject.close();
  }));
}

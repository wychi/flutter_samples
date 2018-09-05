import 'dart:async';

import 'package:flutter_app/ico/api.dart';
import 'package:flutter_app/ico/ico_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockApi extends Mock implements Api {}

void main() {
  group("bloc", () {
    test('normal', () {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenAnswer((_) {
        return Future.value([{}]);
      });

      scheduleMicrotask(() => bloc.requestData());

      expect(
        bloc.stateStream,
        emitsInOrder(
            [BlocState.START, BlocState.LOADING, BlocState.DATA_READY]),
      );
    });

    test('empty data', () {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenAnswer((_) {
        return Future.value([]);
      });

      scheduleMicrotask(() => bloc.requestData());
      expect(
        bloc.stateStream,
        emitsInOrder(
            [BlocState.START, BlocState.LOADING, BlocState.DATA_EMPTY]),
      );
    });

    test('throws an error when the backend errors', () {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenThrow("error");

      scheduleMicrotask(() => bloc.requestData());
      expect(
        bloc.stateStream,
        emitsInOrder([BlocState.START, BlocState.LOADING, BlocState.ERROR]),
      );
    });

    test('refresh', () async {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenAnswer((_) {
        return Future.value([
          {"id": "5"}
        ]);
      });

      expect(
        bloc.stateStream,
        emitsInOrder(
            [BlocState.START, BlocState.LOADING, BlocState.DATA_READY]),
      );

      bloc.requestData();
      await bloc.stateStream.any((state) => state == BlocState.DATA_READY);

      expect(bloc.getItemCount(), 1);
      print("next ");

      {
        when(api.requestData()).thenAnswer((_) {
          return Future.value([
            {"id": "4"}
          ]);
        });
        await bloc.refresh();
        expect(bloc.getItemCount(), 2);
      }

      {
        when(api.requestData()).thenAnswer((_) {
          return Future.value([]);
        });
        await bloc.refresh();
        expect(bloc.getItemCount(), 2);
      }
    });

    test('loadmore', () async {
      var PAGE0 = [
        {"id": "5"}
      ];

      var PAGE1 = [
        {"id": "4"},
        {"id": "3"}
      ];

      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenAnswer((_) {
        return Future.value(PAGE0);
      });

      expect(
        bloc.stateStream,
        emitsInOrder(
            [BlocState.START, BlocState.LOADING, BlocState.DATA_READY]),
      );

      expect(bloc.getItemCount(), 0);

      bloc.requestData();
      await bloc.stateStream.any((state) => state == BlocState.DATA_READY);

      expect(bloc.getItemCount(), PAGE0.length);

      // Note: named arguments
      // GOOD: argument matchers include their names.
      when(api.requestData(
        page: anyNamed("page"),
        limit: anyNamed("limit"),
      )).thenAnswer((_) {
        return Future.value(PAGE1);
      });

      // Note: create another stream for comparison
      expect(
        new StreamView(bloc.stateStream),
        emitsInOrder([BlocState.LOAD_MORE, BlocState.DATA_READY]),
      );

      await bloc.loadMore();
      expect(bloc.getItemCount(), equals(PAGE0.length + PAGE1.length));
    });
  });

  test('remove item', () async {
    var PAGE0 = [
      {"id": "1"},
      {"id": "2"},
      {"id": "3"}
    ];

    final api = MockApi();
    final bloc = BloC(api);

    when(api.requestData()).thenAnswer((_) {
      return Future.value(PAGE0);
    });

    bloc.requestData();
    await bloc.stateStream.any((state) => state == BlocState.DATA_READY);

    expect(
      new StreamView(bloc.stateStream),
      emitsInOrder([BlocState.DATA_READY]),
    );

    bloc.removeItem(0);
    expect(bloc.getItemCount(), PAGE0.length - 1);
  });
}

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
  });
}

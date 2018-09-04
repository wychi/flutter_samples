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
  });
}

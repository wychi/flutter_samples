import 'package:flutter_app/ico_watchlist_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockApi extends Mock implements Api {}

void main() {
  var kData = new List<Map<String, dynamic>>.generate(10, (idx) {
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
    return mapData;
  });

  group("bloc", () {
    test('normal', () {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenAnswer((_) {
        return Future.value(kData);
      });

      expect(
        bloc.requestData(),
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

      expect(
        bloc.requestData(),
        emitsInOrder(
            [BlocState.START, BlocState.LOADING, BlocState.DATA_EMPTY]),
      );
    });

    test('throws an error when the backend errors', () {
      final api = MockApi();
      final bloc = BloC(api);

      when(api.requestData()).thenThrow("error");

      expect(
        bloc.requestData(),
        emitsInOrder([BlocState.START, BlocState.LOADING, BlocState.ERROR]),
      );
    });
  });
}

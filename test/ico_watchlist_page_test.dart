import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_app/ico_watchlist_page.dart';
import 'package:flutter_app/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helper.dart';

void main() {
  var kItems = new List<IcoItemViewModel>.generate(10, (idx) {
    var name = "My Very LongNameCoin";
    var symbol = "$idx";
    var stage = IcoStage.PreSale;
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

  testWidgets('long text', mockTester((WidgetTester tester) async {
    await tester.pumpWidget(
      wrap(
        IcoWatchlistPage.forTest(),
      ),
    );
  }));
}

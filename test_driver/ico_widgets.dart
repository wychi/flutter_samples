import 'package:flutter/material.dart';
import 'package:flutter_app/ico/ico_ongoing_item.dart';
import 'package:flutter_app/ico/ico_watchlist_item.dart';
import 'package:flutter_app/ico/models.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'my_test_app.dart';

void main() {
  enableFlutterDriverExtension();

  runApp(MyTestApp(
    builder: (context) {
      return Column(
        children: <Widget>[
          _buildIcoOngoingItem(context),
          _buildIcoWatchItem(context),
        ],
      );
    },
  ));
}

Widget _buildIcoWatchItem(BuildContext context) {
  var name = "Not Started Coin Not Started Coin";
  var symbol = "LNC";
  var stage = IcoStage.PreSale;
  var startTs = DateTime(2025, 5, 20).millisecondsSinceEpoch;

  var mapData = <String, dynamic>{
    "name": name,
    "symbol": symbol,
    "stage": stage,
    "startTs": startTs,
  };

  return IcoWatchListItem.sample(new IcoItemViewModel(mapData));
}

Widget _buildIcoOngoingItem(BuildContext context) {
  var item = {
    "name": "KimeraKimeraKimera",
    "symbol": "KIMERA",
    "category": "Business Services & Consulting",
    "score": "4.7"
  };

  var onItemClicked = () {
    showDialog(
        context: context,
        builder: (context) {
          return Text("item clicked");
        });
  };
  var onButtonClicked = () {
    showDialog(
        context: context,
        builder: (context) {
          return Text("button clicked");
        });
  };
  return IcoOngoingItem(
    name: item["name"],
    symbol: item['symbol'],
    category: item['category'],
    score: item['score'],
    onItemClicked: onItemClicked,
    onAlertClicked: onButtonClicked,
    onFavoriteClicked: onButtonClicked,
    idx: 1,
  );
}

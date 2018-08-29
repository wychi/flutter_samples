import 'package:flutter/material.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_app/models.dart';

class BloC {
  void initState() {}

  void dispose() {}

  IcoItemViewModel getItem(int idx) {
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
      "onItemClicked": () => print("abc")
    };
    return new IcoItemViewModel(mapData);
  }

  int getItemCount() => 1;
}

class IcoWatchlistPage extends StatefulWidget {
  final BloC mockBloc;

  IcoWatchlistPage({this.mockBloc});

  @override
  _IcoWatchlistPageState createState() => _IcoWatchlistPageState();

  factory IcoWatchlistPage.forTest(BloC mockBloC) {
    return IcoWatchlistPage(mockBloc: mockBloC);
  }
}

class _IcoWatchlistPageState extends State<IcoWatchlistPage> {
  BloC _bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _bloc.getItemCount(),
        itemBuilder: (context, idx) {
          IcoItemViewModel viewModel = _bloc.getItem(idx);
          return IcoWatchListItem.sample(viewModel);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc = widget.mockBloc ?? new BloC();
    _bloc.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}

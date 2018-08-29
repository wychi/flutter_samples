import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ico_watchlist_item.dart';
import 'package:flutter_app/loading_widget.dart';
import 'package:flutter_app/models.dart';
import 'package:flutter_app/my_error_widget.dart';

enum BlocState { START, NA, LOADING, ERROR, DATA_READY, LOAD_MORE }

class BloC {
  BlocState _state = BlocState.START;
  get state => _state;
  set state(value) {
    _state = value;
    _stateController.add(_state);
  }

  StreamController<BlocState> _stateController;
  Stream<BlocState> get stream => _stateController.stream;

  void initState() {
    _stateController = new StreamController(onListen: () {});
  }

  void dispose() {
    _stateController?.close();
    _stateController = null;
  }

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
      "onItemClicked": () => print("onItemClicked"),
      "onMenuClicked": () => print("onMenuClicked")
    };
    return new IcoItemViewModel(mapData);
  }

  int getItemCount() => 10;

  void requestData() {
    state = BlocState.LOADING;
  }
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
    return StreamBuilder(
      initialData: _bloc.state,
      stream: _bloc.stream,
      builder: (context, snapshot) {
        print("_IcoWatchlistPageState snapshot= $snapshot");
        var state = snapshot.data;
        var current;

        switch (state) {
          case BlocState.LOADING:
            current = LoadingWidget();
            break;
          case BlocState.DATA_READY:
            current = _buildListView(context);
            break;
          case BlocState.ERROR:
            current = MyErrorWidget();
            break;
          default:
            current = Container();
        }

        return current;
      },
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

  Widget _buildListView(BuildContext context) {
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
}

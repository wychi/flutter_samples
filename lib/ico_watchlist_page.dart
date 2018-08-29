import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    _stateController = new StreamController(onListen: () {
      requestData();
    });
  }

  void dispose() {
    _stateController?.close();
    _stateController = null;
  }

  IcoItemViewModel getItem(int idx) {
    print('getItem $idx');
    return new IcoItemViewModel(_data[idx]);
  }

  int getItemCount() => _data?.length ?? 0;

  List<Map<String, dynamic>> _data;

  Future<Null> requestData() async {
    state = BlocState.LOADING;

    HttpClient client = new HttpClient();
    try {
      var request = await client
          .getUrl(Uri.parse('https://api.ratingtoken.io/token/ICORankList'));

      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      var list = json.decode(responseBody)['data']['list'] as List<dynamic>;

      var stage = "PreSale";
      var startTs = DateTime.now();

      _data = list.take(10).cast<Map<String, dynamic>>().map((mapData) {
        return {
          "name": mapData['currency'],
          "symbol": mapData['symbol'],
          "stage": stage,
          "startTs": startTs,
        };
      }).toList(growable: false);

      state = BlocState.DATA_READY;
    } catch (error) {
      print(error);
      state = BlocState.ERROR;
    }
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

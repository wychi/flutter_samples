import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ico/api.dart';
import 'package:flutter_app/ico/models.dart';
import 'package:rxdart/rxdart.dart';

enum BlocState { START, NA, LOADING, ERROR, DATA_READY, DATA_EMPTY, LOAD_MORE }

class LoadingViewModel extends IcoItemViewModel {
  LoadingViewModel(Map<String, dynamic> mapData) : super(mapData);
}

class BloC {
  PublishSubject<BlocState> _subject;
  Stream<BlocState> _stateStream;
  Stream<BlocState> get stateStream => _stateStream;
  BlocState _state = BlocState.START;
  get state => _state;

  void _updateState(BlocState newState) {
    _state = newState;
    _subject.add(_state);
  }

  Api _api;
  List<Map<String, dynamic>> _data = [];
  int _page = 0;
  final _limit = 5;

  Future _requestDataTask;
  Future _loadMoreTask;

  BloC(Api api)
      : assert(api != null),
        _api = api {
    _subject = new PublishSubject<BlocState>();
    _stateStream = _subject.stream;
  }

  void initState() {}

  void dispose() {}

  IcoItemViewModel getItem(int idx) {
    // TODO: how to show loading item without causing too much build()
    if (_loadMoreTask != null && idx == getItemCount() - 1) {
      return new LoadingViewModel({});
    }

    return new IcoItemViewModel(_data[idx]);
  }

  int getItemCount() => (_data?.length ?? 0) + (_loadMoreTask != null ? 1 : 0);

  void requestData() {
    _requestData().listen(this._updateState);
  }

  Stream<BlocState> _requestData() async* {
    print("_requestData");

    if (_requestDataTask != null) {
      yield BlocState.LOADING;
      return;
    }

    try {
      yield BlocState.START;

      yield BlocState.LOADING;
//      await Future.delayed(new Duration(seconds: 2));

      _page = 0;
      _requestDataTask = _api.requestData(page: _page, limit: _limit);
      var data = await _requestDataTask;

      _data.clear();
      _data.addAll(data);

      if (_data.isEmpty) {
        yield BlocState.DATA_EMPTY;
      } else {
        yield BlocState.DATA_READY;
      }
    } catch (error) {
      print(error);
      yield BlocState.ERROR;
    } finally {
      _requestDataTask = null;
    }
  }

  Future<void> refresh() async {
    print("refresh");

//      await Future.delayed(new Duration(seconds: 2));

    try {
      _page = 0;

      final data = await _api.requestData(page: _page, limit: _limit);
      _data = new List<Map<String, dynamic>>.from(data)..addAll(_data);

      _updateState(BlocState.DATA_READY);
    } catch (error) {
      print(error);
      _updateState(BlocState.ERROR);
    }
  }

  Future<void> loadMore() async {
    print("loadMore page=${_page + 1}");

    _updateState(BlocState.LOAD_MORE);
    await Future.delayed(new Duration(seconds: 1));

    try {
      var newPage = _page + 1;
      final data = await _api.requestData(page: newPage, limit: _limit);
      _data.addAll(data);

      _page = newPage;
      _updateState(BlocState.DATA_READY);
    } catch (error) {
      print(error);
      _updateState(BlocState.ERROR);
    }
  }

  bool onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (_loadMoreTask == null &&
        metrics.extentAfter < metrics.extentInside / 2) {
      _loadMoreTask = loadMore();

      _loadMoreTask.whenComplete(() {
        print("completed");
        _loadMoreTask = null;
      });
    }

    return false;
  }
}

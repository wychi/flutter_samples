import 'dart:async';

import 'package:flutter_app/ico/api.dart';
import 'package:flutter_app/models.dart';
import 'package:rxdart/rxdart.dart';

enum BlocState { START, NA, LOADING, ERROR, DATA_READY, DATA_EMPTY, LOAD_MORE }

class BloC {
  PublishSubject<BlocState> _subject;
  Stream<BlocState> _stateStream;
  Stream<BlocState> get stateStream => _stateStream;
  BlocState _state = BlocState.START;
  get state => _state;

  Api _api;
  List<Map<String, dynamic>> _data;

  BloC(Api api)
      : assert(api != null),
        _api = api {
    _subject = new PublishSubject<BlocState>();
    _stateStream = _subject.startWith(state);
  }

  void initState() {}

  void dispose() {}

  IcoItemViewModel getItem(int idx) {
    print('getItem $idx');
    return new IcoItemViewModel(_data[idx]);
  }

  int getItemCount() => _data?.length ?? 0;

  void requestData() {
    _requestData().listen((state) {
      if (_state != state) {
        _state = state;
        _subject.add(_state);
      }
    });
  }

  Stream<BlocState> _requestData() async* {
    yield BlocState.START;

    try {
      yield BlocState.LOADING;
      _data = await _api.requestData();

      await Future.delayed(new Duration(seconds: 2));

      if (_data.isEmpty) {
        yield BlocState.DATA_EMPTY;
      } else {
        yield BlocState.DATA_READY;
      }
    } catch (error) {
      yield BlocState.ERROR;
    }
  }
}

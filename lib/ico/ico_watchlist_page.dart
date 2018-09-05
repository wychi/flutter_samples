import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/ico/api.dart';
import 'package:flutter_app/ico/ico_bloc.dart';
import 'package:flutter_app/ico/ico_watchlist_item.dart';
import 'package:flutter_app/ico/models.dart';
import 'package:flutter_app/loading_widget.dart';
import 'package:flutter_app/my_error_widget.dart';

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
    _bloc.requestData();
    return StreamBuilder(
      initialData: _bloc.state,
      stream: _bloc.stateStream,
      builder: (context, snapshot) {
        print("_IcoWatchlistPageState snapshot= $snapshot");
        var state = snapshot.data;
        var current;

        switch (state) {
          case BlocState.LOADING:
            current = LoadingWidget();
            break;
          case BlocState.LOAD_MORE:
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
    _bloc = widget.mockBloc ?? new BloC(new Api());
    _bloc.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget _buildListView(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: _bloc.refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: _bloc.onScroll,
          child: ListView.builder(
            itemCount: _bloc.getItemCount(),
            itemBuilder: (context, idx) {
              IcoItemViewModel viewModel = _bloc.getItem(idx);
              if (viewModel is LoadingViewModel) {
                print("show loading widget");
                return LoadingWidget();
              }

              viewModel.mapData['onMenuClicked'] = (action) async {
                bool remove =
                    await _promptRemoveItemDialog(context, viewModel, idx);
                if (remove) {
                  _bloc.removeItem(idx, viewModel);
                }
              };

              return IcoWatchListItem.sample(viewModel);
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _promptRemoveItemDialog(
      BuildContext context, IcoItemViewModel item, int idx) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: new Text("remove item"),
          content: new SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "remove #$idx",
                ),
                Text(item.name)
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            new FlatButton(
              child: new Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/card_widget.dart';
import 'package:flutter_app/ico/models.dart';
import 'package:flutter_app/styles.dart';
import 'package:intl/intl.dart';

const IMAGE_URL =
    "https://imgtokens.ksmobile.com/4746_PSKToDhFeEVzEFym29Tq8GaE5lAoKhC8i9YW3w9o-151x151.png";
enum IcoStage { PreSale, PreSale_Whitelist }

enum MENU_OPTIONS { REMOVE }

class IcoWatchListItem extends StatelessWidget {
  final bool forDesign;
  final String name;
  final String symbol;
  final String iconUrl;
  final IcoStage stage;
  final DateTime startTs;
  final MenuCallback onMenuClicked;
  final VoidCallback onItemClicked;

  IcoWatchListItem({
    this.name,
    this.symbol,
    this.iconUrl,
    this.stage,
    int startTs,
    this.onMenuClicked,
    this.onItemClicked,
    this.forDesign = false,
  }) : startTs = DateTime.fromMillisecondsSinceEpoch(startTs);

  factory IcoWatchListItem.forDesignTime() {
    return new IcoWatchListItem(forDesign: true);
  }

  @visibleForTesting
  factory IcoWatchListItem.sample(IcoItemViewModel item) {
    return new IcoWatchListItem(
      name: item.name ?? "Ankr Network",
      symbol: item.symbol ?? "ANKR",
      iconUrl: IMAGE_URL,
      stage: item.stage == "PreSale"
          ? IcoStage.PreSale
          : IcoStage.PreSale_Whitelist,
      startTs: item.startTs.millisecondsSinceEpoch ??
          DateTime.now().add(Duration(days: 1000)).millisecondsSinceEpoch,
      onMenuClicked: item.onMenuClicked,
      onItemClicked: item.onItemClicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onItemClicked ??
          () {
            print("onItemClicked is not given. use empty function");
          },
      child: CardWidget(
        onMenuClicked: onMenuClicked ??
            (action) {
              print("onMenuClicked is not given. use empty function");
            },
        child: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildTitleBar(),
        buildDivider(),
        buildStatusDetail(),
      ],
    );
  }

  SizedBox buildTitleBar() {
    return SizedBox(
      height: 64.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.0,
          ),
          buildRoundImage(iconUrl),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: forDesign ? 98.5 : 0.0,
                minHeight: forDesign ? 19.0 : 0.0,
              ),
              child: Container(
                child: Text(
                  name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Styles.text_large_bold.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.0,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 34.5 : 0.0,
              minHeight: forDesign ? 18.0 : 0.0,
            ),
            child: Container(
              width: 34.5,
              height: 18.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Styles.cnm_white_10pa,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              child: Text(
                symbol,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Styles.text_xxsmall.copyWith(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 44.0,
          ),
        ],
      ),
    );
  }

  Padding buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Divider(
        height: 1.0,
        color: Color(0x0fffffff),
      ),
    );
  }

  SizedBox buildStatusDetail() {
    var strStage = "";
    switch (stage) {
      case IcoStage.PreSale:
        strStage = "Presale";
        break;
      case IcoStage.PreSale_Whitelist:
        strStage = "Presale whitelist";
        break;
    }

    var opened = startTs.difference(DateTime.now()).isNegative;
    var current;
    if (!opened) {
      current = buildPresale(strStage);
    } else {
      current = buildOpened(strStage);
    }

    return SizedBox(
      height: 68.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 17.5, 16.0, 17.5),
        child: Container(
          child: current,
        ),
      ),
    );
  }

  Widget buildOpened(String strStage) {
    var strOpenState = "Opened";

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 57.5 : 0.0,
              minHeight: forDesign ? 19.0 : 0.0,
            ),
            child: Container(
              child: new Text(strStage,
                  style: Styles.text_large.copyWith(color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 48.5 : 0.0,
              minHeight: forDesign ? 19.0 : 0.0,
            ),
            child: Container(
              child: Text(
                strOpenState,
                style: Styles.text_large_bold
                    .copyWith(color: Styles.cnm_green_500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Stack buildPresale(String strStage) {
    var days = DateTime.now().difference(startTs).inDays;
    var strStartDate =
        "Start date: ${DateFormat("yyyy-MM-dd").format(startTs)}";
    var strOpenState = "opens in";
    var strOpenDays = "$days Days";
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          left: 0.0,
          top: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 57.5 : 0.0,
              minHeight: forDesign ? 19.0 : 0.0,
            ),
            child: Container(
              child: new Text(strStage,
                  style: Styles.text_large.copyWith(color: Colors.white)),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 44.5 : 0.0,
              minHeight: forDesign ? 12.0 : 0.0,
            ),
            child: Container(
              child: Text(
                strOpenState,
                style:
                    Styles.text_xsmall.copyWith(color: Styles.cnm_orange_500),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 109.0 : 0.0,
              minHeight: forDesign ? 12.0 : 0.0,
            ),
            child: Container(
              child: Text(
                strStartDate,
                style:
                    Styles.text_xsmall.copyWith(color: Styles.cnm_white_40pa),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0.0,
          bottom: 0.0,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: forDesign ? 48.5 : 0.0,
              minHeight: forDesign ? 19.0 : 0.0,
            ),
            child: Container(
              child: Text(
                strOpenDays,
                style: Styles.text_large_bold
                    .copyWith(color: Styles.cnm_orange_500),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container buildRoundImage(String imageUrl) {
    return Container(
      decoration:
          BoxDecoration(color: Styles.cnm_white, shape: BoxShape.circle),
      width: 24.0,
      height: 24.0,
      alignment: Alignment.center,
      child: Image(
        width: 20.0,
        height: 20.0,
        image: NetworkImage(imageUrl),
      ),
    );
  }
}

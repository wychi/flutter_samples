import 'package:flutter/material.dart';
import 'package:flutter_app/styles.dart';

const IMAGE_URL =
    "https://imgtokens.ksmobile.com/4746_PSKToDhFeEVzEFym29Tq8GaE5lAoKhC8i9YW3w9o-151x151.png";

class IcoOngoingItem extends StatelessWidget {
  final int idx;
  final String name;
  final String symbol;
  final String category;
  final String score;
  final bool favoriteAdded;
  final bool alertAdded;

  final bool forDesign;

  var onItemClicked;
  var onFavoriteClicked;
  var onAlertClicked;

  IcoOngoingItem({
    @required this.name,
    @required this.symbol,
    @required this.category,
    @required this.score,
    @required this.idx,
    bool forDesign = false,
    this.alertAdded = false,
    this.favoriteAdded = false,
    this.onItemClicked,
    this.onAlertClicked,
    this.onFavoriteClicked,
  })  : assert(name != null),
        assert(symbol != null),
        assert(category != null),
        assert(score != null),
        assert(idx != null),
        forDesign = forDesign;

  factory IcoOngoingItem.forTest(
      [Map<String, dynamic> item, int idx = 10, bool forDesign = false]) {
    if (item == null) {
      item = {
        "name": "KimeraKimeraKimera",
        "symbol": "KIMERA",
        "category": "Business Services & Consulting",
        "score": "4.7"
      };
    }

    return IcoOngoingItem(
      name: item["name"],
      symbol: item['symbol'],
      category: item['category'],
      score: item['score'],
      alertAdded: item['alert_added'],
      favoriteAdded: item['favorite_added'],
      onItemClicked: item['onItemClicked'],
      onAlertClicked: item['onAlertClicked'],
      onFavoriteClicked: item['onFavoriteClicked'],
      idx: idx,
      forDesign: forDesign,
    );
  }

  factory IcoOngoingItem.forDesignTime() {
    // TODO: add arguments
    const ITEM = {
      "name": "Kimera",
      "symbol": "KIMERA",
      "category": "Business Services & Consulting",
      "score": "4.7"
    };

    return IcoOngoingItem.forTest(ITEM, 1, true);
  }

  Widget _forDesignVisibility({Widget child, int minWidth, int minHeight}) {
    if (!forDesign) return child;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: forDesign ? 6.5 : 0.0,
        minHeight: forDesign ? 12.0 : 0.0,
      ),
      child: new Text("$idx", style: Styles.text_xsmall),
    );
  }

  Widget _buildCard({BuildContext context, Widget child}) {
    return GestureDetector(
      onTap: onItemClicked ?? () {},
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1B224E),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      context: context,
      child: Stack(
        children: <Widget>[
          Container(
            height: 88.0,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 28.0,
                  child: _forDesignVisibility(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("$idx",
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Styles.text_xsmall
                              .copyWith(color: Styles.cnm_white_40pa)),
                    ),
                  ),
                ),
                buildRoundImage(IMAGE_URL),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: _forDesignVisibility(
                              child: Text(
                                name,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                style: Styles.text_large_bold
                                    .copyWith(color: Styles.cnm_white),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 50.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Styles.cnm_white_10pa,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 4.0),
                                child: Text(
                                  symbol,
                                  maxLines: 1,
                                  style: Styles.text_xxsmall
                                      .copyWith(color: Styles.cnm_white_60pa),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        category,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: Styles.text_xsmall
                            .copyWith(color: Styles.cnm_white_40pa),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 84.0,
                )
              ],
            ),
          ),
          Positioned(
            right: 44.0,
            bottom: 0.0,
            child: SizedBox(
              width: 40.0,
              child: IconButton(
                key: Key("add_alert"),
                icon: Icon(Icons.add_alert),
                iconSize: 20.0,
                color:
                    alertAdded ? Styles.cnm_orange_300 : Styles.cnm_white_40pa,
                onPressed: onAlertClicked ?? () {},
              ),
            ),
          ),
          Positioned(
            right: 4.0,
            bottom: 0.0,
            child: SizedBox(
              width: 40.0,
              child: IconButton(
                key: Key("add_favorite"),
                icon: Icon(Icons.star_border),
                iconSize: 20.0,
                padding: const EdgeInsets.all(0.0),
                color: favoriteAdded
                    ? Styles.cnm_orange_300
                    : Styles.cnm_white_40pa,
                onPressed: onFavoriteClicked ?? () {},
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
                width: 48.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: Styles.cnm_indigo_700_60pa,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(6.0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  score,
                  style:
                      Styles.text_xsmall_bold.copyWith(color: Styles.cnm_white),
                )),
          )
        ],
      ),
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

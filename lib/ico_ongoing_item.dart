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

  bool forDesign = false;

  IcoOngoingItem({
    @required this.name,
    @required this.symbol,
    @required this.category,
    @required this.score,
    @required this.idx,
  })  : assert(name != null),
        assert(symbol != null),
        assert(category != null),
        assert(score != null),
        assert(idx != null);

  factory IcoOngoingItem.forTest(Map<String, String> item, [int idx = 1]) {
    return IcoOngoingItem(
      name: item["name"],
      symbol: item['symbol'],
      category: item['category'],
      score: item['score'],
      idx: idx,
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

    return IcoOngoingItem.forTest(ITEM)..forDesign = true;
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
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B224E),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: child,
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
                  width: 8.0,
                ),
                _forDesignVisibility(
                  child: Text("$idx", style: Styles.text_xsmall),
                ),
                SizedBox(
                  width: 13.5,
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
                            width: 12.0,
                          ),
                          Container(
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
                                style: Styles.text_xxsmall
                                    .copyWith(color: Styles.cnm_white_60pa),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(category, style: Styles.text_xsmall),
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
                onPressed: () {},
                icon: Icon(Icons.add_alert),
                color: Styles.cnm_white_40pa,
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
                onPressed: () {},
                icon: Icon(Icons.star_border),
                color: Styles.cnm_white_40pa,
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
                child: Text(score)),
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

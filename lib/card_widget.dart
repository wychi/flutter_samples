import 'package:flutter/material.dart';
import 'package:flutter_app/styles.dart';

typedef MenuCallback = void Function(String action);

class CardWidget extends StatelessWidget {
  final Widget child;
  final MenuCallback onMenuClicked;

  CardWidget({this.child, this.onMenuClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B224E),
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Stack(
          children: <Widget>[
            child,
            buildMenu(),
          ],
        ),
      ),
    );
  }

  Positioned buildMenu() {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 44.0,
        height: 44.0,
        child: LayoutBuilder(
          builder: (context, _) {
            return IconButton(
              key: Key("menu"),
              onPressed: () async {
                final RenderBox button = context.findRenderObject();
                print(context);

                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject();
                final RelativeRect position = new RelativeRect.fromRect(
                  new Rect.fromPoints(
                    button.localToGlobal(button.size.bottomRight(Offset.zero)),
                    button.localToGlobal(button.size.bottomRight(Offset.zero)),
                  ),
                  Offset.zero & overlay.size,
                );

                print(position);

                var action = await showMenu(
                    context: context,
                    position: position,
                    items: <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "remove",
                        child: const Text('Remove'),
                      ),
                    ]);

                if (onMenuClicked != null) onMenuClicked(action);
              },
              icon: Icon(Icons.more_vert),
              color: Styles.cnm_white,
            );
          },
        ),
      ),
    );
  }
}

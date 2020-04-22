import 'package:flutter/material.dart';

// AppBar
Widget buildAppBar() {
  return new AppBar(
    elevation: 0,
    centerTitle: true,
    title: new Text("Rss阅读器"),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.more_horiz,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
  );
}

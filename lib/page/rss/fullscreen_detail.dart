import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/page/main/components/rss_content.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class FullScreenDetail extends StatelessWidget {
  final RSSItem rssItem;

  const FullScreenDetail({Key key, @required this.rssItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        GetPlatform.isDesktop
            ? WindowTitleBarBox(child: MoveWindow())
            : Container(),
        AppBar(
          backgroundColor: Colors.transparent,
          title:
              Text(rssItem?.title ?? "主页", style: TextStyle(color: kTextColor)),
          elevation: 0,
          leading: Container(),
          actions: [
            Row(children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close_fullscreen, color: kGrayColor)),
              SizedBox(width: kDefaultPadding / 2)
            ])
          ],
        ),
        Expanded(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.all(kDefaultPadding),
          child: RSSContent(item: rssItem),
        )))
      ],
    ));
  }
}

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
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
        WindowTitleBarBox(child: MoveWindow()),
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
          child: HtmlWidget(
            // todo 修改初始界面
            rssItem?.content ?? kDefaultHtml,
            // set the default styling for text
            textStyle: TextStyle(fontSize: 15, height: 1.7, color: kTextColor),
            hyperlinkColor: kBadgeColor,
            // turn on `webView` if you need IFRAME support
            webView: true,
            buildAsync: true,
          ),
        )))
      ],
    ));
  }
}

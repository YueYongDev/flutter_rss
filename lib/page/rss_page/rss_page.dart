import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/rss_page/rss_detail.dart';
import 'package:flutter_rss/page/rss_page/rss_parse.dart';
import 'package:flutter_rss/utils/adaptive.dart';

class RssPage extends StatefulWidget {
  RssPage({Key key, this.rss}) : super(key: key);
  final Rss rss;

  @override
  _RssPageState createState() => _RssPageState();
}

class _RssPageState extends State<RssPage> {
  @override
  Widget build(BuildContext context) {
    var isDesktop = isDisplayDesktop(context);
    if (isDesktop) {
      return Row(
        children: [
          Expanded(
            child: RssList(rss: this.widget.rss),
            flex: 1,
          ),
          const VerticalDivider(width: 0.5),
          Expanded(flex: 2, child: RssDetail(rssItem: new RssItem()))
        ],
      );
    } else {
      return new RssList(rss: this.widget.rss);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

// ignore: must_be_immutable
class RssDetail extends StatefulWidget {
  final String htmlString;
  final String url;
  final String title;

  RssDetail({this.title, this.url, this.htmlString});

  @override
  _RssDetailState createState() => _RssDetailState();
}

class _RssDetailState extends State<RssDetail> {
  String htmlString;
  String url;
  String title;

  @override
  void initState() {
    super.initState();
    url = this.widget.url;
    title = this.widget.title;
    htmlString = this.widget.htmlString;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Column(
          children: [Expanded(child: buildRssDetail())],
        ));
  }

  // 显示rss的内容，这里是核心部分，暂时先用webview代替，后面自己写解析器
  Widget buildRssDetail() {
    return new SingleChildScrollView(
      child: Html(
        data: htmlString,
        onImageTap: (src) {
          debugPrint(src);
        },
        onLinkTap: (url) async {
          debugPrint(url);
          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false);
          }
        },
        padding: EdgeInsets.all(8.0),
        linkStyle: const TextStyle(
          color: Colors.redAccent,
          decorationColor: Colors.redAccent,
          decoration: TextDecoration.underline,
        ),
        customTextAlign: (dom.Node node) {
          if (node is dom.Element) {
            switch (node.localName) {
              case "p":
                return TextAlign.justify;
            }
          }
          return null;
        },
        customTextStyle: (dom.Node node, TextStyle baseStyle) {
          if (node is dom.Element) {
            switch (node.localName) {
              case "p":
                return baseStyle.merge(TextStyle(height: 2, fontSize: 16));
            }
          }
          return baseStyle;
        },
      ),
    );
//    return WebView(
//      key: UniqueKey(),
//      initialUrl: (htmlString == null || htmlString == '') ? url : htmlString,
//      javascriptMode: JavascriptMode.unrestricted,
//    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Browser extends StatelessWidget {
  const Browser({Key key, this.url, this.title, this.htmlString})
      : super(key: key);

  final String htmlString;
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: () async {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              })
        ],
      ),
      body: WebView(
        key: UniqueKey(),
        initialUrl: (htmlString == null || htmlString == '') ? url : htmlString,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

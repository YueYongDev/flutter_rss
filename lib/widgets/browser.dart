import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

WebViewController controllerGlobal;

// pan
Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}

class Browser extends StatelessWidget {
  const Browser({Key key, this.url, this.title, this.htmlString})
      : super(key: key);

  final String htmlString;
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
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
          initialUrl:
              (htmlString == null || htmlString == '') ? url : htmlString,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("weixin://")) {
              launch(request.url);
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}

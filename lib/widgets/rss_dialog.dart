import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/rss_page/rss_page.dart';
import 'package:flutter_rss/page/rss_page/rss_parse.dart';

class AddRssDialog extends StatefulWidget {
  AddRssDialog({Key key}) : super(key: key);

  @override
  _AddRssDialogState createState() => _AddRssDialogState();
}

class _AddRssDialogState extends State<AddRssDialog> {
  String input = "";

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).addRssSubscriptionDialogTitle),
      content: Container(
        height: 90,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new GestureDetector(
                  child: Text(
                    S.of(context).paste,
                    style: new TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                  onTap: () async {
                    ClipboardData data =
                        await Clipboard.getData(Clipboard.kTextPlain);
                    if (data != null) {
                      setState(() {
                        _controller.text = data.text;
                        this.input = data.text;
                      });
                    }
                  },
                ),
                new SizedBox(width: 10),
                new GestureDetector(
                    child: Text(S.of(context).clear,
                        style:
                            new TextStyle(fontSize: 12, color: Colors.green)),
                    onTap: () {
                      setState(() {
                        _controller.text = '';
                        this.input = '';
                      });
                    }),
//                // todo 之后把rss推荐这里安排一下
//                new GestureDetector(
//                  child: Text(S.of(context).recommend,
//                      style: new TextStyle(fontSize: 12, color: Colors.orange)),
//                  onTap: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return Browser(title: "MyRSSHub", url: Urls.myrsshub);
//                    }));
//                  },
//                ),
//                new GestureDetector(
//                  child: Text("RSS HUB",
//                      style: new TextStyle(fontSize: 12, color: Colors.orange)),
//                  onTap: () {
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return Browser(title: "RSSHub", url: Urls.rsshub);
//                    }));
//                  },
//                )
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: S.of(context).feedsAddress,
                  filled: true,
                  fillColor: Colors.white),
              onChanged: (val) {
                this.input = val;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).cancel),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (RegexUtil.isURL(input)) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new RssPage(rss: new Rss(url: input))),
              );
            } else {
              EasyLoading.showError(S.of(context).illegalLink);
            }
          },
          child: Text(S.of(context).next),
        ),
      ],
    );
  }
}

class EditRssDialog extends StatefulWidget {
  final url;

  EditRssDialog({Key key, this.url}) : super(key: key);

  @override
  _EditRssDialogState createState() => _EditRssDialogState();
}

class _EditRssDialogState extends State<EditRssDialog> {
  String input = '';

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    input = this.widget.url;
    _controller.text = this.widget.url;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).updateRssSubscriptionDialogTitle),
      content: Container(
        height: 90,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: S.of(context).feedsAddress,
                  filled: true,
                  fillColor: Colors.white),
              onChanged: (val) {
                this.input = val;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(S.of(context).cancel),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (RegexUtil.isURL(input)) {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new RssList(rss: new Rss(url: input))));
            } else {
              EasyLoading.showError(S.of(context).illegalLink);
            }
          },
          child: Text(S.of(context).next),
        ),
      ],
    );
  }
}

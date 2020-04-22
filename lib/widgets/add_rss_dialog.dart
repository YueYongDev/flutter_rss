import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/common/url_string.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/rss_parse.dart';
import 'package:flutter_rss/widgets/browser.dart';

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
      title: Text('添加订阅源'),
      content: Container(
        height: 90,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new GestureDetector(
                  child: Text(
                    "粘贴",
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
                new GestureDetector(
                    child: Text("清空",
                        style:
                            new TextStyle(fontSize: 12, color: Colors.green)),
                    onTap: () {
                      setState(() {
                        _controller.text = '';
                        this.input = '';
                      });
                    }),
                // todo 之后把rss推荐这里安排一下
                new GestureDetector(
                  child: Text("RSS 推荐",
                      style: new TextStyle(fontSize: 12, color: Colors.orange)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Browser(title: "MyRSSHub", url: Urls.myrsshub);
                    }));
                  },
                ),
                new GestureDetector(
                  child: Text("RSS HUB",
                      style: new TextStyle(fontSize: 12, color: Colors.orange)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Browser(title: "RSSHub", url: Urls.rsshub);
                    }));
                  },
                )
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  labelText: '订阅源地址', filled: true, fillColor: Colors.white),
              onChanged: (val) {
                debugPrint(val);
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
          child: Text('取消'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            if (RegexUtil.isURL(input)) {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new RssParse(rss: new Rss(url: input))));
            } else {
              EasyLoading.showError('不合法的链接');
            }
          },
          child: Text('下一步'),
        ),
      ],
    );
  }
}

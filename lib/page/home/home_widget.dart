import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/services/db_services.dart';

import '../rss_parse.dart';

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

// 首页的每个 item 表示一个 Rss 信息
Widget buildRssItem(BuildContext context, List rssSource, int index) {
  List<Color> colors = [
    Colors.grey,
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.orange,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.teal,
    Colors.black
  ];
  Rss rss = rssSource[index];
  return Column(
    children: [
      GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: colors[index % rssSource.length]
//                image: DecorationImage(
//                    image: NetworkImage(rss.logo), fit: BoxFit.cover),
              ),
          child: Text(rss.title.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new RssParse(rss: rss)),
          );
        },
        // todo 长按从底部弹出更新或删除选项
        onLongPress: () {
          showCupertinoModalPopup<int>(
              context: context,
              builder: (cxt) {
                var dialog = CupertinoActionSheet(
                  title: Text("整理"),
                  cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(cxt, 1);
                      },
                      child: Text("Cancel")),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(cxt, 2);
                        },
                        child: Text('修改')),
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(cxt, 3);
                          DBServices.delete(rss.id);
                          // 通过eventBus通知主页刷新
                          bus.emit("refresh");
                        },
                        child: Text('删除')),
                  ],
                );
                return dialog;
              });
        },
      ),
      SizedBox(height: 10),
      Text(
        rss.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      )
    ],
  );
}

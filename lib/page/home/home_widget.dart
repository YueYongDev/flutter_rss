import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/services/db_services.dart';

import '../rss_parse.dart';

const appBarDesktopHeight = 158.0;

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    Key key,
    this.isDesktop = false,
  }) : super(key: key);

  final bool isDesktop;

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      title: isDesktop ? null : Text("标题"),
      bottom: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsetsDirectional.fromSTEB(72, 0, 0, 22),
                child: Text(
                  "Rss阅读器",
                  style: themeData.textTheme.headline6.copyWith(
                    color: themeData.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: "分享",
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          tooltip: "收藏",
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: "搜索",
          onPressed: () {},
        ),
      ],
    );
  }
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

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/common/sp_constant.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/rss_page/rss_page.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/widgets/rss_dialog.dart';

const appBarDesktopHeight = 158.0;

class AdaptiveAppBar extends StatefulWidget implements PreferredSizeWidget {
  AdaptiveAppBar({Key key, this.isDesktop}) : super(key: key);

  final bool isDesktop;

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(kToolbarHeight);

  @override
  _AdaptiveAppBarState createState() => _AdaptiveAppBarState();
}

class _AdaptiveAppBarState extends State<AdaptiveAppBar> {
  bool isDesktop;

  @override
  void initState() {
    super.initState();
    isDesktop = this.widget.isDesktop;
    // 监听语言切换事件
    bus.on("locale", (arg) {
      String language = SpUtil.getString(SpConstant.LANGUAGE);
      setState(() {
        if (language == "zh") S.load(Locale('zh', 'CN'));
        if (language == "en") S.load(Locale('en', 'US'));
      });
    });
  }

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: !isDesktop,
      title: isDesktop ? null : Text(S.of(context).appName),
      bottom: isDesktop
          ? PreferredSize(
              preferredSize: const Size.fromHeight(26),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                margin: const EdgeInsetsDirectional.fromSTEB(72, 0, 0, 22),
                child: Text(
                  S.of(context).appName,
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
          onPressed: () {
            EasyLoading.showToast(S.of(context).notAvailable);
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: "搜索",
          onPressed: () {
            EasyLoading.showToast(S.of(context).notAvailable);
          },
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
              color: colors[index % rssSource.length]),
          child: Text(rss.title.substring(0, 1),
              style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new RssPage(rss: rss)),
          );
        },
        // 长按从底部弹出更新或删除选项
        onLongPress: () {
          showCupertinoModalPopup<int>(
              context: context,
              builder: (cxt) {
                var dialog = CupertinoActionSheet(
                  cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(cxt, 1);
                      },
                      child: Text(S.of(context).cancel)),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(cxt, 2);
                          // 弹出修改对话框
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  EditRssDialog(url: rss.url));
                        },
                        child: Text(S.of(context).edit)),
                    CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(cxt, 3);
                          DBServices.delete(rss.id);
                          // 通过eventBus通知主页刷新
                          bus.emit("refresh");
                        },
                        child: Text(S.of(context).delete)),
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

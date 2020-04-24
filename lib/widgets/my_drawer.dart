// 侧边栏顶部样式
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/constant.dart';
import 'package:flutter_rss/utils/adaptive.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:flutter_rss/widgets/my_drawer_header.dart';
import 'package:provider/provider.dart';

// 左侧边栏
class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    String _colorKey;

    final isDesktop = isDisplayDesktop(context);

    return new Drawer(
        child: new SafeArea(
            child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        MyDrawerHeader(),
        ListTile(
          leading: Icon(Icons.calendar_view_day, color: Colors.black54),
          title: Text('整理'),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
          },
        ),
        Divider(),
        Container(
            child: Text('设置', style: TextStyle(color: Colors.black54)),
            margin: EdgeInsets.only(left: 10)),
        ExpansionTile(
          leading: Icon(Icons.color_lens),
          title: Text('颜色主题'),
          initiallyExpanded: false,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: themeColorMap.keys.map((key) {
                  Color value = themeColorMap[key];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _colorKey = key;
                      });
                      SpUtil.putString(Constant.keyThemeColor, key);
                      Provider.of<AppInfoProvider>(context, listen: false)
                          .setTheme(key);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: value,
                      child: _colorKey == key
                          ? Icon(
                              Icons.done,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.black54),
          title: Text('清空缓存'),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.settings, color: Colors.black54),
          title: Text('设置'),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: Colors.black54),
          title: Text('关于'),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    )));
  }
}

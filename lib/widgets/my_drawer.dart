// 侧边栏顶部样式
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/sp_constant.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/utils/adaptive.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:flutter_rss/widgets/about_dialog.dart';
import 'package:flutter_rss/widgets/my_drawer_header.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// 左侧边栏
class MyDrawer extends StatefulWidget {
  MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _colorKey;

  bool _lights = false;

  String groupValue = 'zh';

  @override
  void initState() {
    super.initState();
    groupValue = SpUtil.getString(SpConstant.LANGUAGE, defValue: 'zh');
  }

  @override
  void dispose() {
    super.dispose();
    bus.off("refresh");
    bus.off("locale");
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return new Drawer(
        child: new SafeArea(
            child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        MyDrawerHeader(),
        Container(
            child: Text(S.of(context).setting,
                style: TextStyle(color: Colors.black54)),
            margin: EdgeInsets.only(left: 10, bottom: 10)),
        buildLanguageItem(),
        buildThemeItem(),
//        //todo 深色模式
//        SwitchListTile(
//          title: const Text('深色模式'),
//          value: _lights,
//          onChanged: (bool value) {
//            setState(() {
//              _lights = value;
//            });
//          },
//          secondary: const Icon(Icons.lightbulb_outline),
//        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.black54),
          title: Text(S.of(context).clearCache),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(S.of(context).warning),
                      content: Text(('确定要清空缓存吗？')),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text(S.of(context).cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text(S.of(context).confirm),
                          onPressed: () {
                            Navigator.of(context).pop();
                            DBServices.dropTableRss();
                            SpUtil.clear();
                            bus.emit("refresh");
                          },
                        ),
                      ],
                    ));
          },
        ),
        // 更多设置
//        ListTile(
//          leading: Icon(Icons.settings, color: Colors.black54),
//          title: Text(S.of(context).moreSetting),
//          onTap: () {
//            if (!isDesktop) {
//              Navigator.pop(context);
//            }
//          },
//        ),
        ListTile(
          leading: Icon(Icons.feedback, color: Colors.black54),
          title: Text(S.of(context).feedback),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
            launch('https://support.qq.com/products/147726');
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline, color: Colors.black54),
          title: Text(S.of(context).aboutItem),
          onTap: () {
            if (!isDesktop) {
              Navigator.pop(context);
            }
            showDialog(context: context, builder: (context) => MyAboutDialog());
          },
        ),
      ],
    )));
  }

  // 切换语言的item
  Widget buildLanguageItem() {
    void _changed(value) {
      if (value != null) {
        SpUtil.putString(SpConstant.LANGUAGE, value);
        setState(() {
          groupValue = value;
          if (value == "zh") S.load(Locale('zh', 'CN'));
          if (value == "en") S.load(Locale('en', 'US'));
        });
        bus.emit("locale");
      }
    }

    return new ExpansionTile(
      title: Text(S.of(context).changeLanguage),
      leading: Icon(Icons.language),
      initiallyExpanded: false,
      children: [
        RadioListTile<String>(
          title: Text('汉语'),
          value: 'zh',
          groupValue: groupValue,
          onChanged: _changed,
        ),
        RadioListTile<String>(
            title: Text('English'),
            value: 'en',
            groupValue: groupValue,
            onChanged: _changed),
      ],
    );
  }

  // 切换主题的item
  Widget buildThemeItem() {
    return new ExpansionTile(
      leading: Icon(Icons.color_lens),
      title: Text(S.of(context).changeTheme),
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
                  SpUtil.putString(SpConstant.keyThemeColor, key);
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
    );
  }
}

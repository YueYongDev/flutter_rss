import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/generated/l10n.dart';

// 侧边栏顶部样式
class MyDrawerHeader extends StatefulWidget {
  MyDrawerHeader({Key key}) : super(key: key);

  @override
  _MyDrawerHeaderState createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return new InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: new CircleAvatar(
              backgroundImage: new AssetImage("assets/icon/icon_person.png"),
            ),
            margin: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 5.0),
          ),
          new ListTile(
            title: Text(
              S.of(context).login,
              style: textTheme.headline6,
            ),
            subtitle: Text(
              S.of(context).displayAfterLogin,
              style: textTheme.bodyText2,
            ),
          ),
          Divider(),
        ],
      ),
      onTap: () {
        EasyLoading.showToast(S.of(context).notAvailable);
      },
    );
  }
}

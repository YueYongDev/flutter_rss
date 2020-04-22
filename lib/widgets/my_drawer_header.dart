import 'package:flutter/material.dart';

// 侧边栏顶部样式
class MyDrawerHeader extends StatefulWidget {
  MyDrawerHeader({Key key}) : super(key: key);

  @override
  _MyDrawerHeaderState createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    return new UserAccountsDrawerHeader(
//      margin: EdgeInsets.zero,
      accountName: new Text(
        "登录",
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: new Text(
        "登录后显示",
        style: TextStyle(color: Colors.white),
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: new AssetImage("assets/icon/icon_person.png"),
      ),
//    otherAccountsPictures: <Widget>[
//      new CircleAvatar(
//        backgroundImage: new AssetImage("images/ymj_shuijiao.gif"),
//      ),
//    ],
    );
  }
}

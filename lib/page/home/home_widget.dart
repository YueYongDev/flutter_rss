import 'package:flutter/material.dart';

// AppBar
Widget buildAppBar() {
  return new AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    centerTitle: true,
    title: new Text("Rss阅读器", style: new TextStyle(color: Colors.black)),
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.more_horiz,
            color: Colors.purple,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      },
    ),
  );
}

// 左侧边栏
Widget buildDrawer(BuildContext context) {
  return new Drawer(
      child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      _drawerHeader(),
//      ListTile(
//        leading: Icon(Icons.calendar_view_day, color: Colors.black54),
//        title: Text('导入'),
//        onTap: () {
//          Navigator.pop(context);
//        },
//      ),
      ListTile(
        leading: Icon(Icons.calendar_view_day, color: Colors.black54),
        title: Text('整理'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      Divider(),
      Container(
          child: Text('设置', style: TextStyle(color: Colors.black54)),
          margin: EdgeInsets.only(left: 10)),
      ListTile(
        leading: Icon(Icons.color_lens, color: Colors.black54),
        title: Text('颜色主题'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.delete, color: Colors.black54),
        title: Text('清空缓存'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.settings, color: Colors.black54),
        title: Text('设置'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: Icon(Icons.info_outline, color: Colors.black54),
        title: Text('关于'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  ));
}

Widget _drawerHeader() {
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

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/components/side_menu.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/screens/rss/rss_detail.dart';
import 'package:get/get.dart';

import 'components/list_of_rss.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;

      // 左侧边栏是否打开
      Widget enableSideMenu = Expanded(
        flex: width > 1340 ? 2 : 4,
        child: Container(
          color: kBgLightColor,
          child: Column(
            children: [
              GetPlatform.isDesktop
                  ? WindowTitleBarBox(child: MoveWindow())
                  : Container(),
              Expanded(child: SideMenu())
            ],
          ),
        ),
      );

      // 中间列表是否展示
      Widget enableRSSList = Expanded(
        flex: width > 1340 ? 3 : 5,
        child: Container(
          color: kBgDarkColor,
          child: Column(
            children: [
              GetPlatform.isDesktop
                  ? WindowTitleBarBox(child: MoveWindow())
                  : Container(),
              Expanded(child: ListOfRSS())
            ],
          ),
        ),
      );

      Widget enableRSSDetail = Expanded(
        flex: width > 1340 ? 8 : 10,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              GetPlatform.isDesktop
                  ? WindowTitleBarBox(child: MoveWindow())
                  : Container(),
              Expanded(child: RSSDetail())
            ],
          ),
        ),
      );

      return Row(
        children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340
          width >= 1100 ? enableSideMenu : Container(),
          width >= 650 ? enableRSSList : Container(),
          width < 650 ? enableRSSList : enableRSSDetail
        ],
      );
    });
  }
}

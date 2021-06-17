import 'package:flutter/material.dart';
import 'package:flutter_rss/components/side_menu_item.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/services/rss_controller.dart';
import 'package:get/get.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SideMenuExpansionTile extends StatefulWidget {
  const SideMenuExpansionTile({Key key}) : super(key: key);

  @override
  _SideMenuExpansionTileState createState() => _SideMenuExpansionTileState();
}

class _SideMenuExpansionTileState extends State<SideMenuExpansionTile> {
  int index = 0;

  // 下拉组件子组件
  List<Widget> buildExpansionTileChild(List<RSSInfo> rssInfoList) {
    List<Widget> widgets = [];
    widgets.add(SideMenuItem(
      press: () {
        RSSController.to.getRSSItemList();
        setState(() {
          index = 0;
        });
      },
      title: "所有订阅",
      iconSrc: "assets/Icons/All.svg",
      isActive: index == 0,
    ));
    for (int i = 1; i <= rssInfoList.length; i++) {
      RSSInfo rssInfo = rssInfoList[i - 1];
      Widget child = SideMenuItem(
        press: () {
          RSSController.to.getRSSItemList(info: rssInfo);
          setState(() => index = i);
        },
        title: rssInfo.title,
        iconSrc: "assets/Icons/Settings.svg",
        isActive: index == i,
      );
      widgets.add(child);
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetBuilder<RSSController>(
          init: RSSController(),
          builder: (v) => ExpansionTile(
              title: Text("已添加订阅",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: kTextColor)),
              leading: WebsafeSvg.asset("assets/Icons/Inbox.svg",
                  height: 20, color: kPrimaryColor),
              initiallyExpanded: false,
              //默认是否展开
              children: buildExpansionTileChild(v.rssInfoList))),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/components/side_menu.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/page/main/components/rss_card.dart';
import 'package:flutter_rss/page/rss/rss_detail.dart';
import 'package:flutter_rss/responsive.dart';
import 'package:flutter_rss/services/rss_controller.dart';
import 'package:get/get.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ListOfRSS extends StatefulWidget {
  const ListOfRSS({
    Key key,
  }) : super(key: key);

  @override
  _ListOfRSSState createState() => _ListOfRSSState();
}

class _ListOfRSSState extends State<ListOfRSS>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _controller;

  bool isLoading = false;

  // 点击的是那个item
  int click = -1;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    super.initState();

    bus.on("refresh_rss", (arg) => getData());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState.openDrawer()),
          if (!Responsive.isDesktop(context)) SizedBox(width: 5),
          Expanded(
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: kBgLightColor,
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 0.75), //15
                  child: WebsafeSvg.asset("assets/Icons/Search.svg", width: 24),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Widget sortBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              print("排序");
              RSSController.to.sortByTime();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WebsafeSvg.asset(
                  "assets/Icons/Sort.svg",
                  width: 22,
                  color: Colors.black,
                ),
                SizedBox(width: 5),
                Text(
                  "按时间排序",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Spacer(),
          // 点击刷新按钮时的旋转动画
          RotationTransition(
            turns: Tween(begin: 0.0, end: 4.0).animate(_controller),
            child: MaterialButton(
              minWidth: 20,
              onPressed: () {
                bus.emit("refresh_rss");
                _controller.forward();
              },
              child: WebsafeSvg.asset(
                "assets/Icons/Refresh.svg",
                width: 16,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _buildHomePageWhenNoRss() {
      return new Container(
        width: double.infinity,
        height: double.infinity,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset("assets/images/Flower.png", width: 80),
            new Container(height: 30),
            new Text("点击左侧菜单添加订阅"),
            new SizedBox(height: 5),
          ],
        ),
      );
    }

    Widget rssList = Expanded(
        child: RefreshIndicator(
      onRefresh: () => getData(type: "pull_down"),
      child: GetBuilder<RSSController>(
          init: RSSController(),
          builder: (v) => v.rssItemList.length == 0
              ? Center(
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : _buildHomePageWhenNoRss())
              : ListView.builder(
                  controller: ScrollController(),
                  itemCount: v.rssItemList.length,
                  itemBuilder: (context, index) => RSSCard(
                    isActive:
                        Responsive.isMobile(context) ? false : index == click,
                    rssItem: v.rssItemList[index],
                    press: () {
                      if (Responsive.isMobile(context)) {
                        Get.to(() => RSSDetail(rssItem: v.rssItemList[index]),
                            fullscreenDialog: true);
                      } else {
                        setState(() {
                          click = index;
                        });
                        bus.emit("open_rss_content", v.rssItemList[index]);
                      }
                    },
                  ),
                )),
    ));

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              searchBar,
              SizedBox(height: kDefaultPadding),
              sortBar,
              SizedBox(height: kDefaultPadding),
              rssList
            ],
          ),
        ),
      ),
    );
  }

  getData({type}) async {
    if (type != "pull_down") {
      if (mounted) setState(() => isLoading = true);
    }
    await RSSController.to.getRSSInfoList();
    if (mounted) setState(() => isLoading = false);
    EasyLoading.showSuccess("订阅已更新");
    _controller.reset();
  }
}

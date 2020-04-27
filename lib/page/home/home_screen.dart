import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/sp_constant.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/page/home/home_widget.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/utils/adaptive.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:flutter_rss/widgets/my_drawer.dart';
import 'package:flutter_rss/widgets/rss_dialog.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isDesktop;

  // Rss订阅源
  List rssSource = [];

  Future future;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  @override
  void dispose() {
    super.dispose();
    // 移除监听事件
    bus.off("refresh");
    bus.off("locale");
  }

  Future<void> _initAsync() async {
    await _getRssData();

    // 监听首页的刷新事件
    bus.on("refresh", (arg) {
      refresh();
    });

    // 监听语言切换事件
    bus.on("locale", (arg) {
      String language = SpUtil.getString(SpConstant.LANGUAGE);
      setState(() {
        if (language == "zh") S.load(Locale('zh', 'CN'));
        if (language == "en") S.load(Locale('en', 'US'));
      });
    });
  }

  _getRssData() async {
    rssSource = await DBServices.getRssList();
    if (mounted) {
      setState(() {
        rssSource = rssSource;
      });
    }
  }

  //刷新数据,重新设置future就行了
  Future refresh() async {
    await _getRssData();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;
    if (isDesktop) {
      return Row(
        children: [
          MyDrawer(),
          const VerticalDivider(width: 1),
          Expanded(
              child: new Scaffold(
                  drawer: MyDrawer(),
                  appBar: AdaptiveAppBar(isDesktop: true),
                  floatingActionButton: _buildFloatingActionButton(),
                  body: new RefreshIndicator(
                    onRefresh: refresh,
                    child: useMobileLayout
                        ? gridViewForPhone(orientation)
                        : gridViewForTablet(orientation),
                  )))
        ],
      );
    } else {
      return new Scaffold(
          drawer: MyDrawer(),
          appBar: AdaptiveAppBar(isDesktop: false),
          floatingActionButton: _buildFloatingActionButton(),
          body: new RefreshIndicator(
            onRefresh: refresh,
            child: useMobileLayout
                ? gridViewForPhone(orientation)
                : gridViewForTablet(orientation),
          ));
    }
  }

  // 手机页面
  Widget gridViewForPhone(Orientation orientation) {
    if (rssSource.length == 0)
      return _buildHomePageWhenNoRss();
    else
      return Padding(
        padding: EdgeInsets.only(top: 25, left: 10, right: 10),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          children: List.generate(rssSource.length, (index) {
            return buildRssItem(context, rssSource, index);
          }),
        ),
      );
  }

  // 平板页面
  Widget gridViewForTablet(Orientation orientation) {
    if (rssSource.length == 0)
      return _buildHomePageWhenNoRss();
    else
      return Padding(
        padding: EdgeInsets.only(top: 25, left: 10, right: 10),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 5,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: List.generate(rssSource.length, (index) {
            return buildRssItem(context, rssSource, index);
          }),
        ),
      );
  }

  // 右下角添加按钮
  Widget _buildFloatingActionButton() {
    if (isDesktop) {
      return new FloatingActionButton.extended(
        heroTag: 'Extended Add',
        icon: Icon(Icons.add),
        onPressed: () {
          // 首页右下角，添加订阅源功能
          showDialog(context: context, builder: (context) => AddRssDialog());
        },
        label: Text(S.of(context).addIconText),
      );
    } else {
      return new FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // 首页右下角，添加订阅源功能
            showDialog(context: context, builder: (context) => AddRssDialog());
          });
    }
  }

// 当本地没有rss订阅源时，显示该界面
  Widget _buildHomePageWhenNoRss() {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset("assets/icon/rss.png", width: 100),
          new Container(height: 30),
          new Text(S.of(context).addSubscription),
          new SizedBox(height: 5),
          new GestureDetector(
              child: new Text(S.of(context).refresh,
                  style: new TextStyle(color: Colors.blue)),
              onTap: refresh)
        ],
      ),
    );
  }
}

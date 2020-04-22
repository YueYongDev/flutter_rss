import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/constant.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/home/home_widget.dart';
import 'package:flutter_rss/page/rss_parse.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:flutter_rss/widgets/add_rss_dialog.dart';
import 'package:flutter_rss/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext context;

  // Rss订阅源
  List rssSource = [];

  Future future;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _getRssData();
    await SpUtil.getInstance();

    String colorKey =
        SpUtil.getString(Constant.keyThemeColor, defValue: 'blue');
    // 设置初始化主题颜色
    Provider.of<AppInfoProvider>(context, listen: false).setTheme(colorKey);

    // 监听首页的刷新事件
    bus.on("refresh", (arg) {
      refresh();
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
    this.context = context;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
        drawer: MyDrawer(),
        appBar: buildAppBar(),
        floatingActionButton: buildFloatingActionButton(),
        body: new RefreshIndicator(
          onRefresh: refresh,
          child: useMobileLayout
              ? gridViewForPhone(orientation)
              : gridViewForTablet(orientation),
        ));
  }

  // 手机页面
  Widget gridViewForPhone(Orientation orientation) {
    if (rssSource.length == 0)
      return buildHomePageWhenNoRss();
    else
      return Padding(
        padding: EdgeInsets.only(top: 25, left: 10, right: 10),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 3 : 4,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          children: List.generate(rssSource.length, (index) {
            return buildRssItem(index);
          }),
        ),
      );
  }

  // 平板页面
  Widget gridViewForTablet(Orientation orientation) {
    if (rssSource.length == 0)
      return buildHomePageWhenNoRss();
    else
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: List.generate(rssSource.length, (index) {
            return buildRssItem(index);
          }),
        ),
      );
  }

  // 首页的每个 item 表示一个 Rss 信息
  Widget buildRssItem(int index) {
    Rss rss = rssSource[index];
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: new Border.all(color: Color(0xFFFF0000), width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
//                image: DecorationImage(
//                    image: NetworkImage(this.cover), fit: BoxFit.cover),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new RssParse(rss: rss)),
            );
          },
          // todo 长按从底部弹出更新或删除选项
          onLongPress: () {
            showCupertinoModalPopup<int>(
                context: context,
                builder: (cxt) {
                  var dialog = CupertinoActionSheet(
                    title: Text("整理"),
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(cxt, 1);
                        },
                        child: Text("Cancel")),
                    actions: <Widget>[
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(cxt, 2);
                          },
                          child: Text('修改')),
                      CupertinoActionSheetAction(
                          onPressed: () {
                            Navigator.pop(cxt, 3);
                            DBServices.delete(rss.id);
                            _getRssData();
                          },
                          child: Text('删除')),
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

  // 右下角添加按钮
  Widget buildFloatingActionButton() {
    return new FloatingActionButton(
//        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          // 首页右下角，添加订阅源功能
          showDialog(context: context, builder: (context) => AddRssDialog());
        });
  }

// 当本地没有rss订阅源时，显示该界面
  Widget buildHomePageWhenNoRss() {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset("assets/icon/rss.png", width: 100),
          new Container(height: 30),
          new Text("点击下方按钮添加开启订阅"),
          new SizedBox(height: 5),
          new GestureDetector(
              child: new Text("刷新", style: new TextStyle(color: Colors.blue)),
              onTap: refresh)
//        new Text("推荐订阅源")
        ],
      ),
    );
  }
}

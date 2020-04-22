import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/common/url_string.dart';
import 'package:flutter_rss/model/Rss.dart';
import 'package:flutter_rss/page/home/home_widget.dart';
import 'package:flutter_rss/page/rss_parse.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/widgets/browser.dart';

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

  String rss = "";

  Future future;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _getRssData();
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

  // 显示添加订阅源对话框
  showAddDialog() {
    TextEditingController _controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('添加订阅源'),
            content: Container(
              height: 90,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new GestureDetector(
                        child: Text(
                          "粘贴",
                          style:
                              new TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                        onTap: () async {
                          ClipboardData data =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          if (data != null) {
                            setState(() {
                              _controller.text = data.text;
                              this.rss = data.text;
                            });
                          }
                        },
                      ),
                      new GestureDetector(
                          child: Text("清空",
                              style: new TextStyle(
                                  fontSize: 12, color: Colors.green)),
                          onTap: () {
                            setState(() {
                              _controller.text = '';
                              this.rss = '';
                            });
                          }),
                      // todo 之后把rss推荐这里安排一下
                      new GestureDetector(
                        child: Text("RSS 推荐",
                            style: new TextStyle(
                                fontSize: 12, color: Colors.orange)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Browser(
                                title: "MyRSSHub", url: Urls.myrsshub);
                          }));
                        },
                      ),
                      new GestureDetector(
                        child: Text("RSS HUB",
                            style: new TextStyle(
                                fontSize: 12, color: Colors.orange)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Browser(title: "RSSHub", url: Urls.rsshub);
                          }));
                        },
                      )
                    ],
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: '订阅源地址',
                        filled: true,
                        fillColor: Colors.white),
                    onChanged: (val) {
                      debugPrint(val);
                      this.rss = val;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (RegexUtil.isURL(rss)) {
                    Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new RssParse(rss: new Rss(url: rss))))
                        .then((val) => val ? _getRssData() : null);
                  } else {
                    EasyLoading.showError('不合法的链接');
                  }
                },
                child: Text('下一步'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final double shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 600.0;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return new Scaffold(
        drawer: buildDrawer(context),
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
        padding: EdgeInsets.all(5.0),
        child: GridView.count(
          crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
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
    return GestureDetector(
      child: Card(
        child: Container(
          alignment: Alignment.center,
          color: Colors.green[100 * (index % 9)],
          child: Text(rss.title),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new RssParse(rss: rss)),
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
                    onPressed: () {}, child: Text("Cancel")),
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
    );
  }

  // 右下角添加按钮
  Widget buildFloatingActionButton() {
    return new FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.purple),
        onPressed: () {
          // 首页右下角，添加订阅源功能
          showAddDialog();
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

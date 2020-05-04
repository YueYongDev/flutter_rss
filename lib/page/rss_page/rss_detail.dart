import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/photo_view.dart';
import 'package:flutter_rss/utils/adaptive.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class RssDetail extends StatefulWidget {
  final RssItem rssItem;

  RssDetail({this.rssItem});

  @override
  _RssDetailState createState() => _RssDetailState();
}

class _RssDetailState extends State<RssDetail> {
  RssItem rssItem;

  String title = '';
  String time = '';
  String url = '';
  String author = '';
  String content = '';

  var isDesktop;

  ScrollController _controller = new ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    rssItem = this.widget.rssItem;
    if (rssItem.title != null) {
      url = rssItem.url;
      title = rssItem.title;
      content = rssItem.content;
      time = rssItem.time;
      author = rssItem.author;
    }
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
//      print(_controller.offset); //打印滚动位置
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });

    // 设置监听事件
    bus.on("setRssItem", (arg) {
      setState(() {
        this.rssItem = arg;
      });
      //返回到顶部时执行动画
      _controller.animateTo(.0,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    bus.off("setRssItem");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDesktop = isDisplayDesktop(context);
    return new Scaffold(
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
                heroTag: '222',
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  //返回到顶部时执行动画
                  _controller.animateTo(.0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                }),
        body: CustomScrollView(
          controller: _controller,
          slivers: [
            buildRssDetailAppBar(rssItem),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(15),
                  child: (rssItem.title == null)
                      ? new Container()
                      : new Column(
                          children: [buildRssHeader(), buildRssDetail(rssItem)],
                        ),
                )
              ]),
            ),
          ],
        ));
  }

  // 构建RSS详情页的appBar
  Widget buildRssDetailAppBar(RssItem item) {
    return SliverAppBar(
      leading: IconButton(
        icon: isDesktop ? Icon(Icons.call_split) : Icon(Icons.arrow_back),
        onPressed: () {
          if (isDesktop) {
            // todo 这里用于将左侧边栏隐藏
          } else {
            Navigator.pop(context, true);
          }
        },
      ),
      title: Text(item.title ?? ""),
      floating: true,
      actions: item.title == null
          ? <Widget>[]
          : <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (item.title != null) {
                      Share.share(item.title +
                          "\n来自：" +
                          item.author +
                          "\n访问：" +
                          item.url +
                          "\n分享自：RSS 阅读器");
                    }
                  }),
              new IconButton(
                  icon: Icon(
                    Icons.add_to_home_screen,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (await canLaunch(item.url)) {
                      await launch(item.url);
                    } else {
                      throw 'Could not launch $item.url';
                    }
                  })
            ],
    );
  }

  Widget buildRssHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(rssItem.title,
            style: TextStyle(color: Colors.black, fontSize: 24)),
        SizedBox(height: 10),
        Text(rssItem.author,
            style: TextStyle(fontSize: 16, color: Colors.black54)),
        SizedBox(height: 5),
        Text(rssItem.time,
            style: TextStyle(fontSize: 14, color: Colors.black54)),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  // 显示rss的内容，自定义解析器
  Widget buildRssDetail(RssItem item) {
    return HtmlWidget(
      item.content,
      factoryBuilder: (hwc) => _MyWidgetFactory(hwc),
      // 允许播放网络视频等
      webView: true,
      // 点击链接后用浏览器打开
      onTapUrl: (url) async {
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        }
      },
      // 设置行高
      textStyle: new TextStyle(height: 1.5),
    );
  }
}

// 修复加载的图片太多的话会出现死机的情况
class _MyWidgetFactory extends WidgetFactory {
  _MyWidgetFactory(HtmlWidgetConfig config) : super(config);

  @override
  Widget buildImage(String url, {double height, String text, double width}) {
    return new Container(child: RssDetailImage(url: url));
  }
}

// Rss详情页中图片加载自定义
class RssDetailImage extends StatefulWidget {
  final String url;

  const RssDetailImage({Key key, this.url}) : super(key: key);

  @override
  _RssDetailImageState createState() => _RssDetailImageState();
}

class _RssDetailImageState extends State<RssDetailImage> {
  @override
  Widget build(BuildContext context) {
    // 直接通过内存加载图片，一方面可以通过异步的网络请求获取图片信息，防止线程阻塞，另一方面可以很好的将byte数组传到下一个页面，方便下载
    return new FutureBuilder(
      future: getImageData(this.widget.url),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // 请求已结束
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return new Center(
                child: GestureDetector(
              child: Container(
                  child: Text('图片加载失败，点击重新加载',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.black45),
              onTap: () {
                getImageData(this.widget.url);
              },
            ));
          } else {
            // 请求成功，显示数据
            return new GestureDetector(
                child: Image.memory(snapshot.data),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => PhotoViewSimpleScreen(
                            imageData: snapshot.data,
                            imageProvider: MemoryImage(snapshot.data),
                            heroTag: 'simple')),
                  );
                });
          }
        } else {
          // 请求未结束，显示loading
          return new Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  getImageData(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    return response.data;
  }
}

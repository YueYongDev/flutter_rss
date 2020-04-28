import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/widgets/view_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RssDetail extends StatefulWidget {
  final RssItem rssItem;

  RssDetail({this.rssItem});

  @override
  _RssDetailState createState() => _RssDetailState();
}

class _RssDetailState extends State<RssDetail> {
  RssItem rssItem;
  String content;
  String url;
  String title;
  String time;
  String author;

  ScrollController _controller = new ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    rssItem = this.widget.rssItem;
    url = rssItem.url;
    title = rssItem.title;
    content = rssItem.content;
    time = rssItem.time;
    author = rssItem.author;

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
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
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
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              title: Text(title),
              floating: true,
              actions: <Widget>[
                new IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    onPressed: url.isEmpty
                        ? null
                        : () {
                            Share.share(title +
                                "\n来自：" +
                                author +
                                "\n访问：" +
                                url +
                                "\n分享自：RSS 阅读器");
                          }),
                new IconButton(
                    icon: Icon(
                      Icons.add_to_home_screen,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    })
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(15),
                  child: new Column(
                    children: [buildRssHeader(), buildRssDetail()],
                  ),
                )
              ]),
            ),
          ],
        ));
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

  // 显示rss的内容，这里是核心部分，暂时先用webview代替，后面自己写解析器
  Widget buildRssDetail() {
    return HtmlWidget(
      content,
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
      // 设置图片的点击事件
      builderCallback: (meta, e) {
        if (e.localName == 'img' && e.attributes.containsKey('src')) {
          meta = lazySet(meta, buildOp: imgOnTap(e.attributes['src']));
        }
        return meta;
      },
    );
  }

  BuildOp imgOnTap(String src) => BuildOp(
        priority: 9999,
        onWidgets: (_, widgets) => widgets.map((widget) => GestureDetector(
              child: widget,
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => PhotoViewSimpleScreen(
                          url: src,
                          loadingChild: new Center(
                              child: new CircularProgressIndicator()),
                          imageProvider: ExtendedNetworkImageProvider(src),
                          heroTag: 'simple')),
                );
              },
              onLongPress: () {},
            )),
      );
}

class _MyWidgetFactory extends WidgetFactory {
  _MyWidgetFactory(HtmlWidgetConfig config) : super(config);

  @override
  Widget buildImage(String url, {double height, String text, double width}) {
    final imageWidget = ExtendedImage.network(url,
        fit: BoxFit.fill,
        enableLoadState: true,
        // ignore: missing_return
        cache: true, loadStateChanged: (ExtendedImageState state) {
      switch (state.extendedImageLoadState) {
        case LoadState.completed:
          return null;
        case LoadState.loading:
          return new Center(child: new CircularProgressIndicator());
          break;
        case LoadState.failed:
          return GestureDetector(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Icon(Icons.warning, color: Colors.red),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Text("load image failed, click to reload",
                      textAlign: TextAlign.center),
                )
              ],
            ),
            onTap: () {
              state.reLoadImage();
            },
          );
          break;
      }
    });
    return imageWidget;
  }
}

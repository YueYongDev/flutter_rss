import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'components/header.dart';

class RSSDetail extends StatefulWidget {
  final RSSItem rssItem;

  const RSSDetail({Key key, this.rssItem}) : super(key: key);

  @override
  _RSSDetailState createState() => _RSSDetailState();
}

class _RSSDetailState extends State<RSSDetail> {
  RSSItem _item;

  ScrollController _controller = new ScrollController();
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  @override
  void initState() {
    super.initState();
    if (ObjectUtil.isNotEmpty(widget.rssItem)) {
      _item = widget.rssItem;
    }
    //监听滚动事件，打印滚动位置
    _controller.addListener(() {
      // print(_controller.offset); //打印滚动位置
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
    bus.on("open_rss_content", (arg) {
      setState(() {
        _item = arg;
      });
      // 切换时需把详情页重置为最顶部
      _controller.jumpTo(.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_upward, color: kGrayColor, size: 20),
              onPressed: () {
                //返回到顶部时执行动画
                _controller.animateTo(.0,
                    duration: Duration(milliseconds: 1000), curve: Curves.ease);
              }),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Header(rssItem: _item),
              Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                    controller: _controller,
                    padding: EdgeInsets.all(kDefaultPadding),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _item?.title ?? "",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: kDefaultPadding / 2),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    maxRadius: 24,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage("assets/images/user_1.png"),
                                  ),
                                  Text(_item?.author ?? "")
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  _item?.time ?? "",
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              )
                            ],
                          ),
                        ),
                        HtmlWidget(
                          // todo 修改初始界面
                          _item?.content ??
                              kDefaultHtml,
                          // all other parameters are optional, a few notable params:

                          // specify custom styling for an element
                          // see supported inline styling below
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },

                          // set the default styling for text
                          textStyle: TextStyle(
                              fontSize: 15, height: 1.7, color: kTextColor),
                          hyperlinkColor: kBadgeColor,
                          // turn on `webView` if you need IFRAME support
                          webView: true,
                          buildAsync: true,
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/page/main/components/rss_content.dart';

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
      // todo 做一个局部刷新
      // if (_controller.offset < 1000 && showToTopBtn) {
      //   setState(() {
      //     showToTopBtn = false;
      //   });
      // } else if (_controller.offset >= 1000 && showToTopBtn == false) {
      //   setState(() {
      //     showToTopBtn = true;
      //   });
      // }
    });
    bus.on("open_rss_content", (arg) {
      setState(() {
        _item = arg;
      });
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
                        RSSContent(item: _item)
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

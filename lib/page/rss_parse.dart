import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/model/Rss.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/services/rss_service.dart';
import 'package:flutter_rss/widgets/browser.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RssParse extends StatefulWidget {
  Rss rss;

  RssParse({this.rss});

  @override
  _RssParseState createState() => _RssParseState();
}

class _RssParseState extends State<RssParse> {
  String title = '';

  Future future;

  @override
  void initState() {
    super.initState();
    future = _getRss();
  }

  // 异步加载的都放到这里
  Future _getRss() async {
    var response;
    // feed信息加载
    Rss rssObj = this.widget.rss;
    // 说明是从对话框跳转来的
    if (rssObj.id == null) {
      debugPrint('from dialog');
      // 若是从对话框跳转来的，先判断是否已经在数据库中
      Rss rss = await DBServices.getRssByUrl(rssObj.url);
      // 若存在，则应该也保存了其type
      if (rss != null) {
        debugPrint('数据库中有该条rss信息:' + rss.toMap().toString());
        // 带type的解析
        response = await RssService().getFeed(rss.url, type: rss.type);
      } else {
        debugPrint('数据库中没有该条rss信息');
        // 不带type的解析
        response = await RssService().getFeed(rssObj.url);
        // 解析成功，将rss信息写入
        if (response != null) {
          saveFeed(response);
        }
      }
    } else {
      debugPrint('from icon');
      // 否则是从首页图标点进来的
      response = await RssService().getFeed(rssObj.url, type: rssObj.type);
    }

    /*这里要延时加载  否则会抱The widget on which setState() or markNeedsBuild() was called was:错误*/
    Future.delayed(Duration(milliseconds: 100)).then((e) {
      if (mounted) {
        setState(() {
          title = response.title;
        });
      }
    });
    return response;
  }

  // 判断当前rss信息是否在数据库中，如果不在，将其添加到数据库中
  saveFeed(var feed) async {
    Rss rss = new Rss();
    rss.title = feed.title;
    rss.url = this.widget.rss.url;
    if (feed.runtimeType.toString() == 'AtomFeed') {
      rss.updateTime = feed.updated;
      rss.logo = feed.logo;
      rss.type = 'atom';
    } else if (feed.runtimeType.toString() == 'RssFeed') {
      rss.updateTime = feed.lastBuildDate;
      rss.logo = feed.image;
      rss.type = 'rss';
    }
    DBServices.insertRss(rss);
  }

  //刷新数据,重新设置future就行了
  Future refresh() async {
    if (mounted) {
      setState(() {
        future = _getRss();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: FutureBuilder(
        builder: _buildFuture,
        future: future,
      ),
      floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            refresh();
          }),
    );
  }

  ///snapshot就是_calculation在时间轴上执行过程的状态快照
  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    debugPrint(snapshot.connectionState.toString());
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print('还没有开始网络请求');
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        print('active');
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        print('waiting');
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        print('done');
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        return _createListView(context, snapshot.data);
      default:
        return new Center(child: new Text("ERROR"));
    }
  }

  Widget _createListView(BuildContext context, final feed) {
    return ListView.builder(
        // todo 之后考虑将这些item全部上传到服务器用做数据分析
        itemCount: feed.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = feed.items[index];
          String type = item.runtimeType.toString();
          String title = item.title;
          String date = '';
          String url = '';
          String author = '';
          String content = '';
          if (type == 'RssItem') {
            debugPrint(item.pubDate);
            date = (item.pubDate == null) ? '' : item.pubDate;
            url = item.link;
            content = item.description;
            author = (item.author == null) ? '' : item.author;
          } else if (type == 'AtomItem') {
            debugPrint(item.published);
            date = (item.published == null) ? '' : item.published;
            url = item.links[0].href;
            content = item.content;
            author = item.authors[0].name;
          } else {}
          try {
            date = (date == '')
                ? ''
                // : TimelineUtil.formatByDateTime(DateTime.parse(date));
                : TimelineUtil.formatByDateTime(
                    DateUtil.getDateTime(date, isUtc: true));
          } on Error {
            date = '';
          }

          return ListTile(
            title: Text(title),
            // todo 更改下时间的表示方式，尽量有好一些
            subtitle: Text(author + " " + date),
            contentPadding: EdgeInsets.all(10.0),
            onTap: () async {
              String tmp =
                  'data:text/html;charset=utf-8;base64,${base64Encode(const Utf8Encoder().convert(content))}';
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new Browser(url: url, htmlString: tmp, title: title)),
              );
            },
          );
        });
  }
}

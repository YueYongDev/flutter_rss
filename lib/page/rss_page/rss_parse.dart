import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/page/rss_page/rss_detail.dart';
import 'package:flutter_rss/services/db_services.dart';
import 'package:flutter_rss/services/rss_service.dart';
import 'package:flutter_rss/utils/adaptive.dart';
import 'package:flutter_rss/utils/common_utils.dart';

class RssList extends StatefulWidget {
  final Rss rss;

  RssList({this.rss});

  @override
  _RssListState createState() => _RssListState();
}

class _RssListState extends State<RssList> {
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
      // 若是从对话框跳转来的，先判断是否已经在数据库中
      Rss rss = await DBServices.getRssByUrl(rssObj.url);
      // 若存在，则应该也保存了其type
      if (rss != null) {
        // 带type的解析
        response = await RssService().getFeed(rss.url, type: rss.type);
      } else {
        // 不带type的解析
        response = await RssService().getFeed(rssObj.url);
        // 解析成功，将rss信息写入
        if (response != null) {
          saveFeed(response);
        }
      }
    } else {
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
      rss.logo = feed.logo == null ? '' : feed.logo;
      rss.type = 'atom';
    } else if (feed.runtimeType.toString() == 'RssFeed') {
      rss.updateTime = feed.lastBuildDate;
      rss.logo = feed.image == null ? '' : feed.image.url;
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
            // 通过eventBus通知主页刷新
            bus.emit("refresh");
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
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        return _createListView(context, snapshot.data);
      default:
        return new Center(child: new Text("ERROR"));
    }
  }

  // 创建RSS Item列表
  Widget _createListView(BuildContext context, final feed) {
    var isDesktop = isDisplayDesktop(context);
    return ListView.builder(
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
            date = item.pubDate ?? "";
            url = item.link ?? "";
            content = item.description ?? "";
            author = item.author ?? '';
            date = CommonUtils.formatGMTTime(date);
          } else if (type == 'AtomItem') {
            date = item.published ?? '';
            url = item.links[0].href ?? "";
            content = item.content;
            author = item.authors[0].name ?? "";
          } else {}
          date = TimelineUtil.formatByDateTime(DateUtil.getDateTime(date));
          RssItem rssItem = new RssItem(
              title: title,
              time: date,
              content: content,
              url: url,
              author: author);
          return ListTile(
            title: Text(title),
            subtitle: Text(author + "  " + date),
            contentPadding: EdgeInsets.all(10.0),
            onTap: () async {
              // 如果是平板的话，就不需要跳转，直接执行刷新操作就可以了
              if (isDesktop) {
                if (rssItem != null && rssItem.title != null)
                  bus.emit('setRssItem', rssItem);
              } else {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RssDetail(rssItem: rssItem)),
                );
              }
            },
          );
        });
  }
}

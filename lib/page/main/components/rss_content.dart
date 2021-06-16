import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// 具体的解析HTML的内容
class RSSContent extends StatelessWidget {
  final RSSItem item;

  const RSSContent({Key key, this.item}) : super(key: key);

  // 点击图片
  onTapImage(ImageMetadata metadata) {
    // todo 点击图片查看大图，并允许保存到本地
    print(metadata.sources.first.url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: HtmlWidget(
            // todo 修改初始界面
            item?.content ?? kDefaultHtml,
            // todo 图片及图片引用居中
            textStyle: TextStyle(fontSize: 15, height: 1.7, color: kTextColor),
            hyperlinkColor: kBadgeColor,
            webView: true,
            buildAsync: true,
            onTapImage: (metadata) => onTapImage(metadata),
            buildAsyncBuilder: (context, snapshot) {
              // 加载时显示加载图标
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CupertinoActivityIndicator());
              return snapshot.data;
            }));
  }
}

// 点击图片
onTapImage(ImageMetadata metadata) {
  // todo 点击图片查看大图，并允许保存到本地
  print(metadata.sources.first.url);
}

Widget buildRSSContent(RSSItem item) {
  return HtmlWidget(
      // todo 修改初始界面
      item?.content ?? kDefaultHtml,
      // todo 图片及图片引用居中
      textStyle: TextStyle(fontSize: 15, height: 1.7, color: kTextColor),
      hyperlinkColor: kBadgeColor,
      webView: true,
      buildAsync: true,
      onTapImage: (metadata) => onTapImage(metadata),
      buildAsyncBuilder: (context, snapshot) {
        // 加载时显示加载图标
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CupertinoActivityIndicator());
        return snapshot.data;
      });
}

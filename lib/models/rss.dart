import 'package:flustars/flustars.dart';
import 'package:webfeed/webfeed.dart';

class RSSInfo {
  String id, title, subtitle, author, url, type, logo, body, updateTime;

  List<RSSItem> items;

  //bool isChecked;

  RSSInfo(
      {this.id,
      this.title,
      this.subtitle,
      this.author,
      this.url,
      this.type,
      this.logo,
      this.body,
      this.items,
      this.updateTime});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'url': url,
      'type': type,
      'logo': logo,
      'body': body,
      'items': items,
      'updateTime': updateTime
    };
  }

  RSSInfo.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    subtitle = map['subtitle'];
    author = map['author'];
    url = map['url'];
    type = map['type'];
    logo = map['logo'];
    body = map['body'];
    updateTime = map['updateTime'];
  }

  RSSInfo.fromAtomFeed(AtomFeed feed) {
    List<RSSItem> list = [];
    feed.items.forEach((item) => list.add(RSSItem.fromAtomFeed(item)));

    id = feed.id;
    title = feed.title;
    subtitle = feed.subtitle;
    url = feed.links?.first?.href;
    type = 'atom';
    logo = feed.icon;
    items = list;
    updateTime = DateUtil.formatDate(feed.updated ?? DateTime.now());
  }

  RSSInfo.fromRssFeed(RssFeed feed) {
    List<RSSItem> list = [];
    feed.items.forEach((item) => list.add(RSSItem.fromRssFeed(item)));
    title = feed.title;
    url = feed.link;
    type = 'rss';
    subtitle = feed.description;
    author = feed.author;
    logo = feed.image?.url;
    items = list;
    updateTime = feed.lastBuildDate ?? DateUtil.formatDate(DateTime.now());
  }
}

class RSSItem {
  String title, url, content, time, author, logo, description;

  RSSItem(
      {this.title,
      this.url,
      this.content,
      this.time,
      this.author,
      this.logo,
      this.description});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'content': content,
      'time': time,
      'author': author
    };
  }

  RSSItem.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    url = map['url'];
    content = map['content'];
    time = map['time'];
    author = map['author'];
  }

  RSSItem.fromAtomFeed(AtomItem item) {
    title = item.title;
    url = item.links.first.href;
    content = item.content;
    time = item.published ?? DateUtil.formatDate(DateTime.now());
    author = item.authors.first.name;
  }

  RSSItem.fromRssFeed(RssItem item) {
    title = item.title;
    url = item.link;
    content = item.description ?? "";
    time = DateUtil.formatDate(item.pubDate ?? DateTime.now());
    author = item.author;
  }
}

import 'package:flustars/flustars.dart';
import 'package:webfeed/webfeed.dart';

class RSSInfo {
  int id;
  String title, url, type, logo, body, updateTime;

  //bool isChecked;

  RSSInfo(
      {this.id,
      this.title,
      this.url,
      this.type,
      this.logo,
      this.body,
      this.updateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type,
      'logo': logo,
      'body': body,
      'updateTime': updateTime
    };
  }

  RSSInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    url = map['url'];
    type = map['type'];
    logo = map['logo'];
    body = map['body'];
    updateTime = map['updateTime'];
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

  Map<String, dynamic> toMap() {
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
    time = item.published;
    author = item.authors.first.name;
  }

  RSSItem.fromRssFeed(RssItem item) {
    title = item.title;
    url = item.link;
    content = item.description ?? "";
    time = DateUtil.formatDate(item.pubDate);
    author = item.author;
  }
}

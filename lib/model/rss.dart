class Rss {
  int id;
  String title;
  String url;
  String type;
  String logo;
  String updateTime;

  Rss({this.id, this.title, this.url, this.type, this.logo, this.updateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type,
      'logo': logo,
      'updateTime': updateTime
    };
  }

  Rss.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    url = map['url'];
    type = map['type'];
    logo = map['logo'];
    updateTime = map['updateTime'];
  }
}

class RssItem {
  String title;
  String url;
  String content;
  String time;
  String author;

  RssItem({this.title, this.url, this.content, this.time,this.author});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'content': content,
      'time': time,
      'author':author
    };
  }

  RssItem.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    url = map['url'];
    content = map['content'];
    time = map['time'];
    author=map['author'];
  }
}

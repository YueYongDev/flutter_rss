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

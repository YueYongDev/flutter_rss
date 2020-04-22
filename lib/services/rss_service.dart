import 'package:dio/dio.dart';
import 'package:webfeed/webfeed.dart';

class RssService {
  Future getFeed(_targetUrl, {String type}) async {
    var dio = new Dio();
    var feed;
    Response response = await dio.get(_targetUrl);
    if (type == null || type == '') {
      try {
        feed = RssFeed.parse(response.data);
      } on Error {
        feed = AtomFeed.parse(response.data);
      }
    } else if (type == 'atom') {
      feed = AtomFeed.parse(response.data);
    } else if (type == 'rss') {
      feed = RssFeed.parse(response.data);
    }
    return feed;
  }
}

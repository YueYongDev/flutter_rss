import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:webfeed/webfeed.dart';
import 'package:string_utility/string_utility.dart';

class RSSService {
  static verifyRSSUrl(String text) async {
    if (ObjectUtil.isEmptyString(text)) {
      return false;
    }
    if (!text.isUrl(protocolMandatory: true)) {
      return false;
    }
    var dio = new Dio();
    Response response = await dio.get(text);
    var feed;
    try {
      feed = RssFeed.parse(response.data);
    } on Error {
      feed = AtomFeed.parse(response.data);
    }
    if (ObjectUtil.isEmpty(feed) && ObjectUtil.isEmpty(feed.items)) {
      return false;
    }
    return true;
  }

  static getRSS() async {
    List<String> _targetUrls = SpUtil.getStringList(kSPKeyRSSUrl, defValue: [
      "https://sspai.com/feed",
      "http://jandan.net/feed",
      "https://rss.cnbeta.com/"
    ]);

    var dio = new Dio();

    List<Response> rsp =
        await Future.wait(_targetUrls.map((element) => dio.get(element)));

    List<RSSItem> list = [];

    rsp.forEach((response) {
      var feed;
      try {
        feed = RssFeed.parse(response.data);
      } on Error {
        feed = AtomFeed.parse(response.data);
      }

      feed.items.forEach((item) {
        RSSItem rss_item = (item is AtomItem)
            ? RSSItem.fromAtomFeed(item)
            : RSSItem.fromRssFeed(item);
        list.add(rss_item);
      });
    });

    return list;
  }
}

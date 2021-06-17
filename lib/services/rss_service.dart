import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:webfeed/webfeed.dart';

class RSSService {
  static verifyRSSUrl(String text) async {
    if (ObjectUtil.isEmptyString(text)) {
      return false;
    }
    if (!GetUtils.isURL(text)) {
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
    return feed;
  }

  // 将信息新增到本地记录中
  static putRSSInfo2Local(RSSInfo info) {
    List<RSSInfo> localRSSInfoList = getLocalRSSInfoList();

    List<RSSInfo> infoList = [];
    if (!ObjectUtil.isEmptyList(localRSSInfoList)) {
      infoList.addAll(localRSSInfoList);
    }
    if (ObjectUtil.isNotEmpty(info)) {
      infoList.add(info);
    }
    SpUtil.putObjectList(kSPKeyRSSInfo, infoList);
  }

  static getLocalRSSInfoList() {
    return SpUtil.getObjList(kSPKeyRSSInfo, (v) => RSSInfo.fromJson(v));
  }

  static getRSSInfoListFromNet() async {
    // https://jesor.me/feed.xml
    List<String> _targetUrls = SpUtil.getStringList(kSPKeyRSSUrl, defValue: []);

    var dio = new Dio();

    // todo 这里做优化，不能把所有链接的请求都加上，不然会出问题，等待时间太久了
    List<Response> rsp =
        await Future.wait(_targetUrls.map((element) => dio.get(element)));

    List<RSSInfo> list = [];
    rsp.forEach((response) {
      var feed;
      try {
        feed = RssFeed.parse(response.data);
      } on Error {
        feed = AtomFeed.parse(response.data);
      }

      RSSInfo info = (feed is AtomFeed)
          ? RSSInfo.fromAtomFeed(feed)
          : RSSInfo.fromRssFeed(feed);
      list.add(info);
    });

    return list;
  }
}

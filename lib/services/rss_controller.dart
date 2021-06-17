import 'package:flustars/flustars.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/services/rss_service.dart';
import 'package:get/get.dart';
import 'package:webfeed/webfeed.dart';

class RSSController extends GetxController {
  // 用于静态访问
  static RSSController get to => Get.find();

  // 用户添加的订阅源信息
  List<RSSInfo> rssInfoList = [];

  // 用户添加的订阅列表信息
  List<RSSItem> rssItemList = [];

  @override
  void onInit() {
    getRSSInfoList();
    super.onInit();
  }

  addRSSInfo(feed) {
    RSSInfo info;
    if (feed is RssFeed) {
      info = RSSInfo.fromRssFeed(feed);
    } else if (feed is AtomFeed) {
      info = RSSInfo.fromAtomFeed(feed);
    } else {
      info = null;
    }
    RSSService.putRSSInfo2Local(info);

    getRSSInfoList();
    update();
  }

  getRSSInfoList() async {
    rssInfoList = await RSSService.getRSSInfoListFromNet();
    getRSSItemList();
    update();
  }

  getRSSItemList({RSSInfo info}) {
    if (ObjectUtil.isNotEmpty(rssInfoList)) {
      rssItemList.clear();
      rssInfoList.forEach((element) => rssItemList.addAll(element.items));
    }
    if (ObjectUtil.isNotEmpty(info)) {
      rssItemList.clear();
      rssItemList.addAll(info.items);
    }
    update();
  }

  sortByTime() {
    // 按照更新时间从前往后排序
    rssItemList.sort((right, left) => left.time.compareTo(right.time));
    update();
  }

  clearAll() {
    SpUtil.clear();
    rssItemList.clear();
    rssInfoList.clear();
    update();
  }
}

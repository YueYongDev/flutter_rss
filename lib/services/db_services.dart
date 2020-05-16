import 'package:flutter/cupertino.dart';
import 'package:flutter_rss/model/rss.dart';
import 'package:flutter_rss/utils/sql_util.dart';

final String dbRss = 'rss.db';
final String tableRss = 'rss';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnUrl = 'url';

//创建对象，传入表名
var sqlRss = SqlUtil.setTable(tableRss);

class DBServices {
// 插入一条 RSS 链接至数据库
  static Future<int> insertRss(Rss rss) async {
    debugPrint('写入一条信息：' + rss.toMap().toString());
    return await sqlRss.insert(rss.toMap());
  }

  // 根据 ID 删除 Rss 信息
  static Future<int> delete(int id) async {
    return sqlRss.delete(columnId, id);
  }

  // 更新 Rss 信息
  static Future<int> update(Rss rss) async {}

  // 根据 Url 查找rss信息
  static Future<Rss> getRssByUrl(String url) async {
    var map = {columnUrl: url};
    List<Map> maps = await sqlRss.query(conditions: map);
    if (maps.length > 0) {
      return Rss.fromMap(maps.first);
    }
    return null;
  }

// 从数据库中获取所有的Rss信息
  static Future<List<Rss>> getRssList() async {
    final List<Map<String, dynamic>> maps =
        await sqlRss.query(conditions: null);
    return List.generate(maps.length, (i) {
      return Rss(
          id: maps[i]['id'],
          title: maps[i]['title'],
          url: maps[i]['url'],
          type: maps[i]['type'],
          logo: maps[i]['logo'],
          updateTime: maps[i]['updateTime']);
    });
  }

  static Future<void> dropTableRss() async {
    sqlRss.db.transaction((txn) async {
      var batch = txn.batch();
      batch.delete(tableRss);
      await batch.commit();
    });
  }
}

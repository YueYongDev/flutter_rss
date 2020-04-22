class SqlTable {
  // 数据库名
  static final String dbName = 'rss.db';

  // 全部使用到的数据表名
  static final String tableRss = 'rss';

  // 将项目中使用的表的表名添加集合中
  static List<String> expectTables = [tableRss];

  static final String sqlCreateTableRss = """
    CREATE TABLE rss(
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, 
      title TEXT NOT NULL, 
      url TEXT NOT NULL,
      type Text NOT NULL,
      logo TEXT,
      updateTime Text NOT NULL
    );
    """;
}

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/sp_constant.dart';

Map<String, Color> themeColorMap = {
  'gray': Colors.grey,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'cyan': Colors.cyan,
  'deepPurple': Colors.purple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'deepOrange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'black': Colors.black,
};

class AppInfoProvider with ChangeNotifier {
  String _themeColor = '';
  String _language = 'zh';

  String get themeColor => _themeColor;

  String get language => _language;

  setLocale(String language) {
    _language = language;
    notifyListeners();
    SpUtil.putString(SpConstant.LANGUAGE, language);
  }

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
    SpUtil.putString(SpConstant.keyThemeColor, themeColor);
  }
}

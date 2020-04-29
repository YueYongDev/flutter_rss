import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/sp_constant.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/page/home_page/home_screen.dart';
import 'package:flutter_rss/services/call_mail_sms_services.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _initAsync() async {
    await SpUtil.getInstance();
    _initLocale();
    _initTheme();
  }

  _initTheme() async {
    String colorKey =
        SpUtil.getString(SpConstant.keyThemeColor, defValue: 'blue');
    // 设置初始化主题颜色
    Provider.of<AppInfoProvider>(context, listen: false).setTheme(colorKey);
  }

  @override
  void initState() {
    super.initState();

    // 注册服务
    setupLocator();
    _initAsync();
  }

  // 初始化语言
  _initLocale() {
    String language = SpUtil.getString(SpConstant.LANGUAGE);
    setState(() {
      if (language == "zh") S.load(Locale('zh', 'CN'));
      if (language == "en") S.load(Locale('en', 'US'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: new HomePage(),
      title: new Text('一款简洁的 RSS 阅读器',
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      image: new Image.asset('assets/icon/logo.png', width: 100, height: 100),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}

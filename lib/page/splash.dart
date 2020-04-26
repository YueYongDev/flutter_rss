import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/common/sp_constant.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/page/home/home_screen.dart';
import 'package:flutter_rss/services/call_mail_sms_services.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // 延时跳转
  jumpPage() {
    return Timer(Duration(milliseconds: 500), () {
      _initAsync().then((value) {
        //跳转并关闭当前页面
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => new HomePage()),
          (route) => route == null,
        );
      });
    });
  }

  _initAsync() async {
    /// App启动时读取Sp数据，需要异步等待Sp初始化完成。
    await SpUtil.getInstance();
    _initLocale();
    // 注册服务
    setupLocator();
  }

  @override
  void initState() {
    super.initState();
    jumpPage();
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
    return Container(
//      child: Image(
//        image: AssetImage('assets/imgs/splash.png'),
//        fit: BoxFit.fill,
//      ),
        );
  }
}

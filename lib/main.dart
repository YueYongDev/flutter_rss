import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:flutter_rss/page/splash.dart';
import 'package:flutter_rss/provider/app_provider.dart';
import 'package:flutter_rss/provider/sql_provider.dart';
import 'package:flutter_rss/utils/event_bus.dart';
import 'package:provider/provider.dart';

var bus = new EventBus();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = new DBProvider();
  await provider.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color _themeColor;
  Locale _locale;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (themeColorMap[colorKey] != null) {
            _themeColor = themeColorMap[colorKey];
          }

          String locale = appInfo.language;
          if (locale == 'zh') {
            _locale = const Locale('zh', 'CN');
          } else if (locale == 'en') {
            _locale = const Locale('en', 'US');
          }

          return FlutterEasyLoading(
              child: MaterialApp(
            // 设置语言
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            // 讲zh设置为第一项,没有适配语言时，英语为首选项
            supportedLocales: S.delegate.supportedLocales,
            // 设置默认语言
            locale: _locale,
            // 去除右上角Debug标签
            debugShowCheckedModeBanner: false,
            title: 'RSS 阅读器',
            theme: ThemeData(
                primaryColor: _themeColor,
                accentColor: _themeColor,
                floatingActionButtonTheme:
                    FloatingActionButtonThemeData(backgroundColor: _themeColor),
                indicatorColor: Colors.white),
            home: SplashPage(),
          ));
        },
      ),
    );
  }
}

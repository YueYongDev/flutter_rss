import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/utils/app_provider.dart';
import 'package:flutter_rss/utils/event_bus.dart';
import 'package:flutter_rss/utils/sql_provider.dart';
import 'package:provider/provider.dart';

import 'page/home/home_screen.dart';

var bus = new EventBus();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = new DBProvider();
  await provider.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _themeColor;

  @override
  void initState() {
    super.initState();
    // 允许横竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

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

          return FlutterEasyLoading(
              child: MaterialApp(
            title: 'Rss',
            theme: ThemeData(
                primaryColor: _themeColor,
                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _themeColor),
                indicatorColor: Colors.white),
            home: HomePage(),
          ));
        },
      ),
    );
  }
}

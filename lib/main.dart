import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/screens/main/main_screen.dart';
import 'package:flutter_rss/utils/event_bus.dart';
import 'package:get/get.dart';

var bus = new EventBus();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(MyApp());
  if (GetPlatform.isDesktop) {
    doWhenWindowReady(() {
      final initialSize = Size(900, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Scaffold(
        body: WindowBorder(
          color: Color(0xFF805306),
          width: 1,
          child: MainScreen(),
        ),
      ),
    );
  }
}

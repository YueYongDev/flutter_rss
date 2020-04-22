//详细视图的Widget,简单的显示一个文本
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/widgets/browser.dart';

class DetailWidget extends StatelessWidget {
  final int data;

  DetailWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: new Center(
          child: data == -1
              ? new Browser(
                  title: "斯是陋室",
                  url: "https://www.liangyueyong.cn",
                )
              : new Text("详细视图:$data"),
        ),
      ),
    );
  }
}

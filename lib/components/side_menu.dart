import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/components/side_menu_expansion_tile.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/responsive.dart';
import 'package:flutter_rss/services/rss_controller.dart';
import 'package:flutter_rss/services/rss_service.dart';
import 'package:get/get.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  _addRSSUrl() async {
    List<String> text = await showTextInputDialog(
        context: Get.context,
        textFields: const [DialogTextField(hintText: '订阅地址')],
        title: '提示',
        message: '请输入要添加的 RSS 链接',
        okLabel: "确定",
        cancelLabel: "取消",
        style: GetPlatform.isAndroid
            ? AdaptiveStyle.material
            : AdaptiveStyle.cupertino);
    if (ObjectUtil.isEmpty(text)) {
      return;
    }
    EasyLoading.show(status: '检验链接合法性...');
    var feed = await RSSService.verifyRSSUrl(text?.first ?? "");
    if (ObjectUtil.isNotEmpty(feed) && feed is bool && feed == false) {
      EasyLoading.dismiss();
      await showOkAlertDialog(
          context: Get.context,
          title: '警告⚠️',
          message: '不合法的链接',
          onWillPop: () => Future.value(false),
          alertStyle: GetPlatform.isAndroid
              ? AdaptiveStyle.material
              : AdaptiveStyle.cupertino);
      return;
    }
    EasyLoading.dismiss();
    List<String> urlsLocal = SpUtil.getStringList(kSPKeyRSSUrl);
    if (urlsLocal.contains(text.first)) {
      EasyLoading.showError("当前订阅链接已添加");
      return;
    }
    EasyLoading.showSuccess("当前订阅链接可用");
    List<String> urls = [];
    urls.addAll(urlsLocal);
    urls.add(text.first);
    SpUtil.putStringList(kSPKeyRSSUrl, urls);

    RSSController.to.addRSSInfo(feed);
    bus.emit("refresh_rss");
  }

  @override
  Widget build(BuildContext context) {
    Widget _addRSSBtn = TextButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kBgDarkColor),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: kDefaultPadding, horizontal: kDefaultPadding * 1.5)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        icon: WebsafeSvg.asset("assets/Icons/Add.svg", width: 16),
        label: Text("添加 RSS 订阅", style: TextStyle(color: kTextColor)),
        onPressed: () => _addRSSUrl());

    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding),
              Row(
                children: [
                  WebsafeSvg.asset("assets/Icons/Logo.svg", width: 48),
                  SizedBox(width: 5),
                  Text("RSS 阅读器"),
                  Spacer(),
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              _addRSSBtn,
              SizedBox(height: kDefaultPadding * 1.5),
              SideMenuExpansionTile(),
              ListTile(
                leading: WebsafeSvg.asset(
                  "assets/Icons/Clear.svg",
                  height: 20,
                  color: kGrayColor,
                ),
                title: Text(
                  "清除缓存",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: kGrayColor),
                ),
                onTap: () => RSSController.to.clearAll(),
              ),

              // SizedBox(height: kDefaultPadding * 2),
              // todo Tags
              // Tags(),
            ],
          ),
        ),
      ),
    );
  }
}

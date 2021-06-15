import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/responsive.dart';
import 'package:flutter_rss/screens/rss/fullscreen_detail.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:websafe_svg/websafe_svg.dart';

class Header extends StatelessWidget {
  final RSSItem rssItem;

  const Header({
    Key key,
    this.rssItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          // We need this back button on mobile only
          if (Responsive.isMobile(context)) BackButton(),
          if (!Responsive.isMobile(context))
            IconButton(
              icon: WebsafeSvg.asset(
                "assets/Icons/Extend.svg",
                width: 24,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            FullScreenDetail(rssItem: rssItem),
                        fullscreenDialog: true));
              },
            ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/Reply.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/Reply all.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/Transfer.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {},
          // ),
          Spacer(),
          // We don't need print option on mobile
          if (Responsive.isDesktop(context))
            IconButton(
              icon: WebsafeSvg.asset(
                "assets/Icons/Printer.svg",
                width: 24,
              ),
              onPressed: () {},
            ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/Markup.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {
          //     print("收藏此文章");
          //   },
          // ),
          IconButton(
            icon: WebsafeSvg.asset(
              "assets/Icons/Share.svg",
              width: 24,
            ),
            onPressed: () {
              if (GetPlatform.isMobile) {
                Share.share(rssItem.url, subject: rssItem.author);
              }
            },
          ),
          IconButton(
            icon: WebsafeSvg.asset(
              "assets/Icons/Browser.svg",
              width: 24,
            ),
            onPressed: () async {
              if (await canLaunch(rssItem.url)) {
                await launch(rssItem.url);
              } else {
                throw 'Could not launch $rssItem.url';
              }
            },
          ),
          // IconButton(
          //   icon: WebsafeSvg.asset(
          //     "assets/Icons/More vertical.svg",
          //     width: 24,
          //   ),
          //   onPressed: () {
          //
          //   },
          // ),
        ],
      ),
    );
  }
}

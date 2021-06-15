import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rss/components/side_menu.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/main.dart';
import 'package:flutter_rss/models/rss.dart';
import 'package:flutter_rss/responsive.dart';
import 'package:flutter_rss/screens/main/components/rss_card.dart';
import 'package:flutter_rss/screens/rss/rss_detail.dart';
import 'package:flutter_rss/services/rss_service.dart';
import 'package:websafe_svg/websafe_svg.dart';

class ListOfRSS extends StatefulWidget {
  // Press "Command + ."
  const ListOfRSS({
    Key key,
  }) : super(key: key);

  @override
  _ListOfRSSState createState() => _ListOfRSSState();
}

class _ListOfRSSState extends State<ListOfRSS> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RSSItem> rss_items = [];

  bool isLoading = false;

  // 点击的是那个item
  int click = -1;

  @override
  void initState() {
    super.initState();
    getRSS();

    bus.on("refresh_rss", (arg) {
      getRSS();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          // Once user click the menu icon the menu shows like drawer
          // Also we want to hide this menu icon on desktop
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
            ),
          if (!Responsive.isDesktop(context)) SizedBox(width: 5),
          Expanded(
            child: TextField(
              onChanged: (value) {},
              decoration: InputDecoration(
                hintText: "Search",
                fillColor: kBgLightColor,
                filled: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding * 0.75), //15
                  child: WebsafeSvg.asset(
                    "assets/Icons/Search.svg",
                    width: 24,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Widget sortBar = Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              print("排序");
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WebsafeSvg.asset(
                  "assets/Icons/Sort.svg",
                  width: 22,
                  color: Colors.black,
                ),
                SizedBox(width: 5),
                Text(
                  "按时间排序",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Spacer(),
          MaterialButton(
            minWidth: 20,
            onPressed: () => bus.emit("refresh_rss"),
            child: WebsafeSvg.asset(
              "assets/Icons/Refresh.svg",
              width: 16,
            ),
          ),
        ],
      ),
    );
    Widget rssList = Expanded(
        child: RefreshIndicator(
      onRefresh: () => getRSS(type: "pull_down"),
      child: isLoading
          ? Center(child: CupertinoActivityIndicator())
          : ListView.builder(
              controller: ScrollController(),
              itemCount: this.rss_items.length,
              // On mobile this active dosen't mean anything
              itemBuilder: (context, index) => RSSCard(
                isActive: Responsive.isMobile(context) ? false : index == click,
                rssItem: this.rss_items[index],
                press: () {
                  if (Responsive.isMobile(context)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RSSDetail(rssItem: this.rss_items[index]),
                          fullscreenDialog: true),
                    );
                  } else {
                    setState(() {
                      click = index;
                    });
                    bus.emit("open_rss_content", this.rss_items[index]);
                  }
                },
              ),
            ),
    ));

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              // This is our Seearch bar
              searchBar,
              SizedBox(height: kDefaultPadding),
              sortBar,
              SizedBox(height: kDefaultPadding),
              rssList
            ],
          ),
        ),
      ),
    );
  }

  getRSS({type}) async {
    if (mounted) setState(() => rss_items.clear());
    if (type != "pull_down") {
      if (mounted) setState(() => isLoading = true);
    }
    List<RSSItem> list = await RSSService.getRSS();
    if (mounted) {
      setState(() {
        this.rss_items = list;
        isLoading = false;
      });
    }
    EasyLoading.showSuccess("订阅已更新");
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/constants.dart';
import 'package:flutter_rss/models/rss.dart';

class RSSCard extends StatelessWidget {
  const RSSCard({
    Key key,
    this.isActive = true,
    this.rssItem,
    this.press,
  }) : super(key: key);

  final bool isActive;
  final RSSItem rssItem;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding / 2, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: isActive ? kPrimaryColor : kBgDarkColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://ui-avatars.com/api/?length=1&rounded=true&background=F5F5F5&name=${rssItem.author}',
                            placeholder: (context, url) =>
                                Center(child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "${rssItem.title} \n",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive ? Colors.white : kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: rssItem.author,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      color:
                                          isActive ? Colors.white : kTextColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            TimelineUtil.formatByDateTime(
                                DateUtil.getDateTime(rssItem.time),
                                locale: "zh"),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  color: isActive ? Colors.white70 : null,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    rssItem.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          height: 1.5,
                          color: isActive ? Colors.white70 : null,
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

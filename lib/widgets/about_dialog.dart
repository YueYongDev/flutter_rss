import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss/generated/l10n.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final textColor=Theme.of(context).primaryColor;

//    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bodyTextStyle =
        textTheme.bodyText1.apply(color: Colors.black);

    final name = 'Rss 阅读器'; // Don't need to localize.
    final legalese = '© 2020 巴格梅克 '; // Don't need to localize.

    final repoText = S.of(context).githubRepo(name);
    final seeSource = S.of(context).aboutDialogDescription(repoText);
    final repoLinkIndex = seeSource.indexOf(repoText);
    final repoLinkIndexEnd = repoLinkIndex + repoText.length;
    final seeSourceFirst = seeSource.substring(0, repoLinkIndex);
    final seeSourceSecond = seeSource.substring(repoLinkIndexEnd);
    final contactMe = S.of(context).contactMe;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: getVersionNumber(),
              builder: (context, snapshot) => Text(
                snapshot.hasData ? '$name ${snapshot.data}' : '$name',
                style: textTheme.headline4.apply(color: Colors.black),
              ),
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    style: bodyTextStyle,
                    text: seeSourceFirst,
                  ),
                  TextSpan(
                    style: bodyTextStyle.copyWith(
                      color: textColor,
                    ),
                    text: repoText,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final url = 'https://github.com/YueYongDev/flutter_rss';
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                          );
                        }
                      },
                  ),
                  TextSpan(
                    style: bodyTextStyle,
                    text: seeSourceSecond,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  style: bodyTextStyle,
                  text: legalese,
                ),
                TextSpan(
                  style: bodyTextStyle.copyWith(
                    color: textColor,
                  ),
                  text: contactMe,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = 'Mailto:yueyong1030@outlook.com';
                      if (await canLaunch(url)) {
                        await launch(
                          url,
                          forceSafariVC: false,
                        );
                      }
                    },
                ),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          textColor: textColor,
          child:
              Text(MaterialLocalizations.of(context).viewLicensesButtonLabel),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  textTheme: Typography.material2018(
                    platform: Theme.of(context).platform,
                  ).black,
                  scaffoldBackgroundColor: Colors.white,
                ),
                child: LicensePage(
                  applicationName: name,
                  applicationLegalese: legalese,
                ),
              ),
            ));
          },
        ),
        FlatButton(
          textColor: textColor,
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

Future<String> getVersionNumber() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get appName {
    return Intl.message(
      'RSS Reader',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  String githubRepo(Object repoName) {
    return Intl.message(
      '$repoName GitHub repository',
      name: 'githubRepo',
      desc: '',
      args: [repoName],
    );
  }

  String aboutDialogDescription(Object repoLink) {
    return Intl.message(
      'This application was built with flutter. To see the source code for this app, please visit the $repoLink.',
      name: 'aboutDialogDescription',
      desc: '',
      args: [repoLink],
    );
  }

  String get contactMe {
    return Intl.message(
      'Contact Me 🙋',
      name: 'contactMe',
      desc: '',
      args: [],
    );
  }

  String get addIconText {
    return Intl.message(
      'Add',
      name: 'addIconText',
      desc: '',
      args: [],
    );
  }

  String get addSubscription {
    return Intl.message(
      'Click the button below to add and open a subscription',
      name: 'addSubscription',
      desc: '',
      args: [],
    );
  }

  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  String get edit {
    return Intl.message(
      'Update Subscription',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  String get delete {
    return Intl.message(
      'Delete Subscription',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  String get changeLanguage {
    return Intl.message(
      'Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  String get changeTheme {
    return Intl.message(
      'Theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  String get clearCache {
    return Intl.message(
      'Clear Cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  String get moreSetting {
    return Intl.message(
      'Settings',
      name: 'moreSetting',
      desc: '',
      args: [],
    );
  }

  String get aboutItem {
    return Intl.message(
      'About',
      name: 'aboutItem',
      desc: '',
      args: [],
    );
  }

  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  String get displayAfterLogin {
    return Intl.message(
      'Display after login',
      name: 'displayAfterLogin',
      desc: '',
      args: [],
    );
  }

  String get notAvailable {
    return Intl.message(
      'Features are not yet available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  String get recommend {
    return Intl.message(
      'Recommend',
      name: 'recommend',
      desc: '',
      args: [],
    );
  }

  String get addRssSubscriptionDialogTitle {
    return Intl.message(
      'Add RSS Subscription',
      name: 'addRssSubscriptionDialogTitle',
      desc: '',
      args: [],
    );
  }

  String get updateRssSubscriptionDialogTitle {
    return Intl.message(
      'Update RSS Subscription',
      name: 'updateRssSubscriptionDialogTitle',
      desc: '',
      args: [],
    );
  }

  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  String get illegalLink {
    return Intl.message(
      'Illegal link',
      name: 'illegalLink',
      desc: '',
      args: [],
    );
  }

  String get feedsAddress {
    return Intl.message(
      'Feeds Address',
      name: 'feedsAddress',
      desc: '',
      args: [],
    );
  }

  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  String get savePicture {
    return Intl.message(
      'Save',
      name: 'savePicture',
      desc: '',
      args: [],
    );
  }

  String get savedSuccess {
    return Intl.message(
      'Success',
      name: 'savedSuccess',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
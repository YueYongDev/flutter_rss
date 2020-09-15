// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `RSS Reader`
  String get appName {
    return Intl.message(
      'RSS Reader',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `A Simple RSS Reader`
  String get appInfo {
    return Intl.message(
      'A Simple RSS Reader',
      name: 'appInfo',
      desc: '',
      args: [],
    );
  }

  /// `{repoName} GitHub repository`
  String githubRepo(Object repoName) {
    return Intl.message(
      '$repoName GitHub repository',
      name: 'githubRepo',
      desc: '',
      args: [repoName],
    );
  }

  /// `This application was built with flutter. To see the source code for this app, please visit the {repoLink}.`
  String aboutDialogDescription(Object repoLink) {
    return Intl.message(
      'This application was built with flutter. To see the source code for this app, please visit the $repoLink.',
      name: 'aboutDialogDescription',
      desc: '',
      args: [repoLink],
    );
  }

  /// `Contact Me 🙋`
  String get contactMe {
    return Intl.message(
      'Contact Me 🙋',
      name: 'contactMe',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get addIconText {
    return Intl.message(
      'Add',
      name: 'addIconText',
      desc: '',
      args: [],
    );
  }

  /// `Click the button below to add and open a subscription`
  String get addSubscription {
    return Intl.message(
      'Click the button below to add and open a subscription',
      name: 'addSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Update Subscription`
  String get edit {
    return Intl.message(
      'Update Subscription',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete Subscription`
  String get delete {
    return Intl.message(
      'Delete Subscription',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get changeLanguage {
    return Intl.message(
      'Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get changeTheme {
    return Intl.message(
      'Theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message(
      'Clear Cache',
      name: 'clearCache',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get moreSetting {
    return Intl.message(
      'Settings',
      name: 'moreSetting',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get aboutItem {
    return Intl.message(
      'About',
      name: 'aboutItem',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Display after login`
  String get displayAfterLogin {
    return Intl.message(
      'Display after login',
      name: 'displayAfterLogin',
      desc: '',
      args: [],
    );
  }

  /// `Features are not yet available`
  String get notAvailable {
    return Intl.message(
      'Features are not yet available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Paste`
  String get paste {
    return Intl.message(
      'Paste',
      name: 'paste',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get recommend {
    return Intl.message(
      'Recommend',
      name: 'recommend',
      desc: '',
      args: [],
    );
  }

  /// `Add RSS Subscription`
  String get addRssSubscriptionDialogTitle {
    return Intl.message(
      'Add RSS Subscription',
      name: 'addRssSubscriptionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update RSS Subscription`
  String get updateRssSubscriptionDialogTitle {
    return Intl.message(
      'Update RSS Subscription',
      name: 'updateRssSubscriptionDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Illegal link`
  String get illegalLink {
    return Intl.message(
      'Illegal link',
      name: 'illegalLink',
      desc: '',
      args: [],
    );
  }

  /// `Feeds Address`
  String get feedsAddress {
    return Intl.message(
      'Feeds Address',
      name: 'feedsAddress',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get savePicture {
    return Intl.message(
      'Save',
      name: 'savePicture',
      desc: '',
      args: [],
    );
  }

  /// `Success`
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
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
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
      'refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  String get edit {
    return Intl.message(
      'edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  String get delete {
    return Intl.message(
      'delete',
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
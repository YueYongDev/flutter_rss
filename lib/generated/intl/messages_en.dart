// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(repoLink) => "This application was built with flutter. To see the source code for this app, please visit the ${repoLink}.";

  static m1(repoName) => "${repoName} GitHub repository";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutDialogDescription" : m0,
    "aboutItem" : MessageLookupByLibrary.simpleMessage("About"),
    "addIconText" : MessageLookupByLibrary.simpleMessage("Add"),
    "addRssSubscriptionDialogTitle" : MessageLookupByLibrary.simpleMessage("Add RSS Subscription"),
    "addSubscription" : MessageLookupByLibrary.simpleMessage("Click the button below to add and open a subscription"),
    "appName" : MessageLookupByLibrary.simpleMessage("RSS Reader"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeLanguage" : MessageLookupByLibrary.simpleMessage("Language"),
    "changeTheme" : MessageLookupByLibrary.simpleMessage("Theme"),
    "clear" : MessageLookupByLibrary.simpleMessage("Clear"),
    "clearCache" : MessageLookupByLibrary.simpleMessage("Clear Cache"),
    "confirm" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "contactMe" : MessageLookupByLibrary.simpleMessage("Contact Me 🙋"),
    "delete" : MessageLookupByLibrary.simpleMessage("Delete Subscription"),
    "displayAfterLogin" : MessageLookupByLibrary.simpleMessage("Display after login"),
    "edit" : MessageLookupByLibrary.simpleMessage("Update Subscription"),
    "feedback" : MessageLookupByLibrary.simpleMessage("Feedback"),
    "feedsAddress" : MessageLookupByLibrary.simpleMessage("Feeds Address"),
    "githubRepo" : m1,
    "illegalLink" : MessageLookupByLibrary.simpleMessage("Illegal link"),
    "login" : MessageLookupByLibrary.simpleMessage("Login"),
    "moreSetting" : MessageLookupByLibrary.simpleMessage("Settings"),
    "next" : MessageLookupByLibrary.simpleMessage("Next"),
    "notAvailable" : MessageLookupByLibrary.simpleMessage("Features are not yet available"),
    "paste" : MessageLookupByLibrary.simpleMessage("Paste"),
    "recommend" : MessageLookupByLibrary.simpleMessage("Recommend"),
    "refresh" : MessageLookupByLibrary.simpleMessage("Refresh"),
    "savePicture" : MessageLookupByLibrary.simpleMessage("Save"),
    "savedSuccess" : MessageLookupByLibrary.simpleMessage("Success"),
    "setting" : MessageLookupByLibrary.simpleMessage("Setting"),
    "updateRssSubscriptionDialogTitle" : MessageLookupByLibrary.simpleMessage("Update RSS Subscription"),
    "warning" : MessageLookupByLibrary.simpleMessage("Warning")
  };
}

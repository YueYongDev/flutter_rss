// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static m0(repoLink) => "该应用通过 Flutter 构建，要查看此应用的源代码，请访问 ${repoLink}。";

  static m1(repoName) => "${repoName} GitHub 代码库";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "aboutDialogDescription" : m0,
    "aboutItem" : MessageLookupByLibrary.simpleMessage("关于"),
    "addIconText" : MessageLookupByLibrary.simpleMessage("添加"),
    "addSubscription" : MessageLookupByLibrary.simpleMessage("点击下方按钮添加开启订阅"),
    "changeLanguage" : MessageLookupByLibrary.simpleMessage("切换语言"),
    "changeTheme" : MessageLookupByLibrary.simpleMessage("切换主题"),
    "clearCache" : MessageLookupByLibrary.simpleMessage("清空缓存"),
    "contactMe" : MessageLookupByLibrary.simpleMessage("联系我 🙋"),
    "delete" : MessageLookupByLibrary.simpleMessage("删除"),
    "edit" : MessageLookupByLibrary.simpleMessage("修改"),
    "githubRepo" : m1,
    "moreSetting" : MessageLookupByLibrary.simpleMessage("更多设置"),
    "refresh" : MessageLookupByLibrary.simpleMessage("刷新"),
    "setting" : MessageLookupByLibrary.simpleMessage("设置")
  };
}

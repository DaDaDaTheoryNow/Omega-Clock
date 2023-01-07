// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "app_bar": {
    "Alarm": "Alarm",
    "Timer": "Timer",
    "hour": "h",
    "Favorite": "Favorite",
    "Settings": "Settings"
  },
  "settings": {
    "Theme": "Theme",
    "Change_sound_of_timer": "Sound of the timer",
    "Reminder_notifications": "Reminder notifications",
    "Change_language": "Change language",
    "language": "English",
    "Thanks_for_using_my_app": "Thanks for using my app!",
    "Your_version_up_to_date": "Your version up to date",
    "Check_update": "Check update",
    "Current_version": "Version"
  }
};
static const Map<String,dynamic> ru = {
  "app_bar": {
    "Alarm": "Будильник",
    "Timer": "Таймер",
    "hour": "ч",
    "Favorite": "Избранные",
    "Settings": "Настройки"
  },
  "settings": {
    "Theme": "Тема",
    "Change_sound_of_timer": "Звук таймера",
    "Reminder_notifications": "Напоминающие уведомления",
    "Change_language": "Изменить язык",
    "language": "Русский",
    "Thanks_for_using_my_app": "Спасибо за использование моего приложения!",
    "Your_version_up_to_date": "Ваша версия актуальная",
    "Check_update": "Проверить обновления",
    "Current_version": "Версия"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru};
}

import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/selectLanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class DynamicTranslation {
  var translator = GoogleTranslator();

  Future<String> stringTranslate({String data}) async {
    String translatedString;
    translatedString =
        (await translator.translate(data, from: 'en', to: selectedLanguage))
            .toString();
    debugPrint("deep translation " + translatedString);
    return translatedString;
  }

}

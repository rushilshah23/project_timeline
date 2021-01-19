import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class DynamicTranslation {
  var translator = GoogleTranslator();
  String toLanguage, fromLanguage;

  getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    toLanguage = sharedPreferences.getString('toLanguage') ?? 'en';
    fromLanguage = sharedPreferences.getString('fromLanguage') ?? 'en';
    return toLanguage;
  }

  Future<String> stringTranslate({String data}) async {
    String translatedString;
    await getLanguage();

    translatedString =
        (await translator.translate(data, from: fromLanguage, to: toLanguage))
            .toString();
    debugPrint("deep translation " + translatedString);
    return translatedString;
  }


  Future<List<String>> listtranslate({List<String> inputs}) async {
    List<String> translatedText = List<String>();
    translatedText.clear();
    await getLanguage();
    debugPrint("from language " + fromLanguage);
    debugPrint("to language " + toLanguage);

    for (var i = 0; i < inputs.length; i++) {
      await translator
          .translate(inputs[i], from: fromLanguage, to: toLanguage)
          .then((value) {
        // debugPrint("translated text is " + value.toString());
        String text = value.toString();
        translatedText.add(text);
      });
    }

    return translatedText;
  }
}

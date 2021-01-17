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
    // return [fromLanguage, toLanguage];

    // language = 'hi';
  }

  Future<String> stringTranslate({String data}) async {
    String translatedString;
    getLanguage();

    translatedString =
        (await translator.translate(data, from: fromLanguage, to: toLanguage))
            .toString();
    debugPrint("deep translation " + translatedString);
    return translatedString;
  }

  // multiTranslation({dynamic data}) async {
  //   int no;
  //   if (data.runtimeType == Map<String, List>()) {
  //     no = 1;
  //     // TODO MAP OF LISTS
  //   } else if (data.runtimeType == Map<String, Map>()) {
  //     no = 2;
  //     // TODO MAP OF MAPS
  //   } else if (data.runtimeType == Map<String, String>()) {
  //     no = 3;
  //     // TODO MAP OF STRINGS
  //   } else if (data.runtimeType == List<List>()) {
  //     no = 4;
  //     // TODO LIST OF LISTS
  //   } else if (data.runtimeType == List<Map>()) {
  //     no = 5;
  //     // TODO LIST OF MAPS
  //   } else if (data.runtimeType == List<String>()) {
  //     no = 6;
  //     // TODO LIST OF STRINGS
  //   }

  //   switch (no) {
  //     case 1:
  //       break;
  //     default:
  //   }
  // }

  Future<Map> mapTranslation({Map<String, dynamic> data}) async {
    Map mainMap = new Map();

    data.forEach((key, value) async {
      if (value.runtimeType == List) {
        List subList = new List();
        subList = await listTranslation(data: value);
        // mainMap.updateAll((key, value) => subList);
        mainMap.update(key, (value) => subList);
      } else if (value.runtimeType == Map) {
        Map subMap = new Map();
        subMap = (await mapTranslation(data: value));
        mainMap.update(key, (value) => subMap);
      } else if (value.runtimeType == String) {
        String subString;
        subString = await stringTranslate(data: value);
        mainMap.update(key, (value) => subString);
      }
    });
    return mainMap;
  }

  Future<List> listTranslation({List<dynamic> data}) async {
    List mainList = new List();

    data.forEach((element) async {
      if (element.runtimeType == List) {
        List subList = new List();
        subList = await listTranslation(data: element);
        mainList.add(subList);
      } else if (element.runtimeType == Map) {
        Map subMap = new Map();
        subMap = await mapTranslation(data: element);
        mainList.add(subMap);
      } else if (element.runtimeType == String) {
        String subString;
        subString = await stringTranslate(data: element);
        mainList.add(subString);
      }
    });
    return mainList;
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

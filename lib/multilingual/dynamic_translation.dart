import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/selectLanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class DynamicTranslation {
  var translator = GoogleTranslator();
  String language;

  getLanguageText() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
   language = _sharedPreferences.getString('language') ?? "en";
  }

  Future<List> listTranslate({List data}) async {
    await getLanguageText();
    if(language!='en'){
    List translatedList=[];
    String translatedString,listToString;
    listToString= data.join("@@@");
     translatedString =
        (await translator.translate(listToString, from: 'en', to: language))
            .toString();
    debugPrint("deep translation " + translatedString);
    translatedList= translatedString.split("@@@").toList();
    return translatedList;
    }
    else return data;
  }

}

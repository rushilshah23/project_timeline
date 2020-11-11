import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';


 Map testStringMap = {
    'a': {
      'a1': 'Home',
      'a2': 'School',
      'a3': 'Garden',
    },
    'b': {
      'b1': 'Country',
      'b2': 'World',
      'b3': 'Island',
    },
    'dynamicTranslate': {
      'c1': ['cricket', 'badminton', 'volleyball', 'football'],
      'c2': ['trees', 'plants', 'creepers', 'mangroves'],
      'c3': ['elephant', 'kangaroo', 'rabbits', 'eagle'],
    },
    'd': "Try this last map string"
  };


void main() async {
  final dynamicTranslate = DynamicTranslate()..translateFunction = getTranslatedValue;
  dynamic output = await dynamicTranslate.translateFunction(testStringMap);
  print("--------------DONE=====-------------" + output.toString());
}


var translator = GoogleTranslator();
String language;

getLanguage() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  language = await sharedPreferences.getString('language');
  return language;
}


class DynamicTranslate {
  dynamic Function(dynamic arg) translateFunction;
}

Future<dynamic> getTranslatedValue(dynamic data) async {
  var translatedOutput;

  print("getTranslatedValue " +      data.toString() +      "  runtype " +      data.runtimeType.toString());

  if (data.runtimeType==String) {
    translatedOutput = await getStringTranslated(data);
  }
  if (data.runtimeType.toString().contains("_InternalLinkedHashMap<")) {
    translatedOutput = await getMapTranslated(data);
  } else if (data.runtimeType.toString().substring(0,4)=="List") {
    translatedOutput =  await getListTranslated(data);
  }

  print("----------------final-----------------" + translatedOutput.toString());
  return  await translatedOutput;
}

getMapTranslated(Map data)   {
  Map translatedOutput = Map();
  translatedOutput.addAll(data);
   data.forEach((key, value) async{
    var subOutput;
    subOutput = await getTranslatedValue(value);
    print("subOutput===" + subOutput.toString() + " for key= " + key.toString());
    translatedOutput[key] = subOutput;
  });

  print("----------------map-----------------" + translatedOutput.toString());
  return translatedOutput;
}

getListTranslated(List data)  async{
  List translatedOutput = [];
  for (int i = 0; i < data.length; i++) {
     translatedOutput.add(await getTranslatedValue(data[i]));
  }
  print("----------------list-----------------" + translatedOutput.toString());
  return translatedOutput;
}

 getStringTranslated(String data) async {
  String translatedOutput="" ;

 await translator.translate(data.toString(), from: 'en', to: 'mr').then((s) {
    print(s);
    translatedOutput= s.toString();     
  }); 
  debugPrint("deep translation " + translatedOutput.toString());
  return translatedOutput;

}

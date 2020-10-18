import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Language with ChangeNotifier {
  String _language;
  bool _languageSelected;
  String translation = '';
  Language(this._language);

  GoogleTranslator _googleTranslator = GoogleTranslator();

  getLang() => _language;
  setLang(String language) {
    _language = language;
    _languageSelected = true;
    notifyListeners();
  }

  get language => _language;
  get languageSelected => _languageSelected;

  Future<String> getTranslation(String input) async {
    print(_language);
    print('translating');

    translation =
        (await _googleTranslator.translate(input, to: language)).toString();
    print('translated');

    notifyListeners();
    return translation;
  }
}

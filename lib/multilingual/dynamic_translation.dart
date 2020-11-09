import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class DynamicTranslation {
  var translator = GoogleTranslator();
  String language;
  List<String> translatedText = List<String>();
  getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    language = sharedPreferences.getString('language');
  }

  Future<List<String>> translate({List<String> inputs}) async {
    translatedText.clear();
    await getLanguage();

    for (var i = 0; i < inputs.length; i++) {
      await translator
          .translate(inputs[i], from: 'en', to: language)
          .then((value) {
        print("translated text is " + value.toString());
        String text = value.toString();
        translatedText.add(text);
        print("see here " + translatedText[0]);
      });
    }
    print("outer loop " + translatedText[1]);
    return translatedText;
  }
}

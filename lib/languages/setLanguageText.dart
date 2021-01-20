import 'package:project_timeline/languages/rawText/bottomNavText.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationEnglish.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationHindi.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationMarathi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextEnglish.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextHindi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextMarathi.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language;
List<String> homePageTranslationText, bottomNavText, feedbackText;

setLanguageText() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  language = _sharedPreferences.getString('language') ?? "en";
  if (language == "en") {
    homePageTranslationText = homePageTranslationTextEnglish;
    bottomNavText = bottomNavTextEnglish;
    feedbackText = feedbackTextEnglish;
  } else if (language == "hi") {
    homePageTranslationText = homePageTranslationTextHindi;
    bottomNavText = bottomNavTextHindi;
    feedbackText = feedbackTextHindi;
  } else if (language == "mr") {
    homePageTranslationText = homePageTranslationTextMarathi;
    bottomNavText = bottomNavTextMarathi;
    feedbackText = feedbackTextMarathi;
  }
}

import 'package:project_timeline/languages/rawText/admin/adminEnglish.dart';
import 'package:project_timeline/languages/rawText/admin/adminHindi.dart';
import 'package:project_timeline/languages/rawText/admin/adminMarathi.dart';
import 'package:project_timeline/languages/rawText/appbarTranslation/appbarTranslationTextEnglish.dart';
import 'package:project_timeline/languages/rawText/appbarTranslation/appbarTranslationTextHindi.dart';
import 'package:project_timeline/languages/rawText/appbarTranslation/appbarTranslationTextMarathi.dart';
import 'package:project_timeline/languages/rawText/bottomNavText.dart';
import 'package:project_timeline/languages/rawText/donationPageTranslation/donationPageTranslationTextEnglish.dart';
import 'package:project_timeline/languages/rawText/donationPageTranslation/donationPageTranslationTextHindi.dart';
import 'package:project_timeline/languages/rawText/donationPageTranslation/donationPageTranslationTextMarathi.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationEnglish.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationHindi.dart';
import 'package:project_timeline/languages/rawText/feedbackTranslation/feedbackTranslationMarathi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/aboutusTranslation/aboutusTranslationTextEnglish.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/aboutusTranslation/aboutusTranslationTextHindi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/aboutusTranslation/aboutusTranslationTextMarathi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextEnglish.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextHindi.dart';
import 'package:project_timeline/languages/rawText/homePageTranslation/homePageTranslationTextMarathi.dart';
import 'package:project_timeline/languages/rawText/supervisorTranslation/supervisorEnglish.dart';
import 'package:project_timeline/languages/rawText/supervisorTranslation/supervisorHindi.dart';
import 'package:project_timeline/languages/rawText/supervisorTranslation/supervisorMarathi.dart';
import 'package:project_timeline/languages/rawText/workerTranslation/workerEnglish.dart';
import 'package:project_timeline/languages/rawText/workerTranslation/workerHindi.dart';
import 'package:project_timeline/languages/rawText/workerTranslation/workerMarathi.dart';
import 'package:shared_preferences/shared_preferences.dart';

String language;
List homePageTranslationText=homePageTranslationTextEnglish = [
  'Gallery',
  'Heat Map',
  'Feedback',
  'LeaderBoard',
  "About Us",
  "Change Language",
  "English",
  "Hindi",
  'Marathi',
  "Language Changed Successfully",
  'Conserve water, conserve life.',
  'You never know the worth of water until the well runs dry. ',
],
    bottomNavText=[
  'Home',
  'Projects',
  'Donations',
  "IAHV",
],
    feedbackText,
    donationPageTranslation,
    workerText,
    workerText2,
    workerDaily,
    logregText,
    proText,
    forgotPassText,
    superText,
    superText2,
    superText3,
    superText4,
    superText5,
    aboutusTranslationText,
    aolTranslationText,
    iahvTranslationText,
    developersTranslationText,
    machinesDataPage,
    petrolPumpDataPage,
    appbarsTranslationText;

setLanguageText() async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  language = _sharedPreferences.getString('language') ?? "en";
  if (language == "en") {
    homePageTranslationText = homePageTranslationTextEnglish;
    bottomNavText = bottomNavTextEnglish;
    feedbackText = feedbackTextEnglish;

    workerText = workerTextEnglish;
    workerText2 = workerText2English;
    workerDaily=workerDailyEnglish;
    logregText = logregTextEnglish;
    proText = proTextEnglish;
    forgotPassText = forgotPassTextEnglish;
    superText = superTextEnglish;
    superText2 = superText2English;
    superText3 = superText3English;
    superText4 = superText4English;
    superText5 = superText5English;

    machinesDataPage = machinesDataPageEnglish;
    petrolPumpDataPage = petrolPumpDataPageEnglish;

    donationPageTranslation = donationPageTranslationEnglish;
    aboutusTranslationText = aboutusTranslationTextEnglish;
    aolTranslationText = aolTranslationTextEnglish;
    iahvTranslationText = iahvTranslationTextEnglish;
    developersTranslationText = developersTextTranslationEnglish;
    appbarsTranslationText = appbarTranslationTextEnglish;
  } else if (language == "hi") {
    homePageTranslationText = homePageTranslationTextHindi;
    bottomNavText = bottomNavTextHindi;
    feedbackText = feedbackTextHindi;

    workerText = workerTextHindi;
    workerText2 = workerText2Hindi;
    workerDaily=workerDailyHindi;
    logregText = logregTextHindi;
    proText = proTextHindi;
    forgotPassText = forgotPassTextHindi;
    superText = superTextHindi;
    superText2 = superText2Hindi;
    superText3 = superText3Hindi;
    superText4 = superText4Hindi;
    superText5 = superText5Hindi;
    machinesDataPage = machinesDataPageHindi;
    petrolPumpDataPage = petrolPumpDataPageHindi;

    donationPageTranslation = donationpageTranslationTextHindi;
    aboutusTranslationText = aboutusTranslationTextHindi;
    aolTranslationText = aolTranslationTextHindi;
    iahvTranslationText = iahvTranslationTextHindi;
    developersTranslationText = developersTextTranslationHindi;
    appbarsTranslationText = appbarTranslationTextHindi;
  } else if (language == "mr") {
    homePageTranslationText = homePageTranslationTextMarathi;
    bottomNavText = bottomNavTextMarathi;
    feedbackText = feedbackTextMarathi;

    workerText = workerTextMarathi;
    workerText2 = workerText2Marathi;
     workerDaily=workerDailyMarathi;
    logregText = logregTextMarathi;
    proText = proTextMarathi;
    forgotPassText = forgotPassTextMarathi;
    superText = superTextMarathi;
    superText2 = superText2Marathi;
    superText3 = superText3Marathi;
    superText4 = superText4Marathi;
    superText5 = superText5Marathi;
    machinesDataPage = machinesDataPageMarathi;
    petrolPumpDataPage = petrolPumpDataPageMarathi;

    donationPageTranslation = donationPageTranslationtextMarathi;
    aboutusTranslationText = aboutusTranslationTextMarathi;
    aolTranslationText = aolTranslationTextMarathi;
    iahvTranslationText = iahvTranslationTextMarathi;
    developersTranslationText = developersTextTranslationMarathi;
    appbarsTranslationText = appbarTranslationTextMarathi;
  }
}

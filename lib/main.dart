import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpgroup/Wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gpgroup/app_localization/app_localizations.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      color: Color(0xff73c5bc),
      title: 'Flutter Demo',
      theme: ThemeData(
      //  primaryColor:  Color(0xff73c5bc),
          primaryColor:  Colors.black.withOpacity(0.6),
       bottomAppBarColor: Colors.lightBlue,

      ),
    supportedLocales: [
    Locale('en', 'US'),
    Locale('gu', 'IN'),
      Locale('hi', 'IN'),
    ],
    // These delegates make sure that the localization data for the proper language is loaded
    localizationsDelegates: [
    // THIS CLASS WILL BE ADDED LATER
    // A class which loads the translations from JSON files
    AppLocalizations.delegate,
    // Built-in localization of basic text for Material widgets
    GlobalMaterialLocalizations.delegate,
    // Built-in localization for text direction LTR/RTL
    GlobalWidgetsLocalizations.delegate,
    ],
    // Returns a locale which will be used by the app
    localeResolutionCallback: (locale, supportedLocales) {
           // Check if the current device locale is supported
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode &&
            supportedLocale.countryCode == locale.countryCode) {

          return supportedLocale;
        }
      }
      // If the locale of the device is not supported, use the first one
      // from the list (English, in this case).
      return supportedLocales.first;
    },
      home: Wrapper(),
    );
  }
}


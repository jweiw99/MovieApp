import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// view
import 'package:movieapp/src/view/splashScreen.dart';
import 'package:movieapp/src/view/homeScreen.dart';

// theme
import 'package:movieapp/src/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // portrait only
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      //top bar color
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      //bottom bar color
      systemNavigationBarColor: Colors.black,
      //systemNavigationBarDividerColor: Colors.grey,
      //systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieApp',
      debugShowCheckedModeBanner: false,
      theme: Themes.getTheme(0),
      initialRoute: '/splashScreen',
      routes: {
        '/homeScreen': (context) => HomeScreen(),
        '/splashScreen': (context) => SplashScreen()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracky/onboarding.dart';
import 'package:tracky/themes/theme_provider.dart';
import 'database/database.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();

  bool colorMode = preferences.getBool("IsDarkTheme") ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(
    MultiProvider(
      providers: [
        Provider<HabitDatabase>(create: (_) => HabitDatabase()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDarkMode: colorMode)),
      ],
      child: const MyApp(),
    ),
  );


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const OnBoarding(),
    );
  }
}

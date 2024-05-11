import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracky/database/database.dart';
import 'package:tracky/themes/theme_provider.dart';

import 'features/home/pages/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  bool colorMode = preferences.getBool("IsDarkTheme") ?? false;

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MultiProvider(providers: [
    //habit provider
    ChangeNotifierProvider(create: (context) => HabitDatabase(),),

    //theme provider
    ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode: colorMode),)
  ], child: const MyApp(),));
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
      home: const HomePage(),
    );
  }
}

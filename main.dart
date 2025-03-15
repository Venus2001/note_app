import 'package:flutter/material.dart';
import 'package:noteapptest/pages/note_page.dart';
import 'package:noteapptest/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'model/note_database.dart';

void main() async {
  //initialaze note isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        //Note Provider
        ChangeNotifierProvider(create: (context) => NoteDatabase()),

        //Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

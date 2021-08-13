import 'dart:async';

import 'package:fluflix/scripts/sqlite.dart';
import 'package:fluflix/ui/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

//pages
import 'package:fluflix/ui/home.dart';
import 'package:fluflix/ui/player.dart';
import 'package:fluflix/ui/category.dart';
import 'package:sqflite/sqflite.dart';

StreamController<bool> isLightTheme = StreamController();
var provider = FavoriteProvider();
openDB() async {
  print("DB init");
  await FavoriteProvider.open('favorite.db');
  print("DB inited");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openDB();
  runApp(FluflixApp());
}

class FluflixApp extends StatefulWidget {
  @override
  _FluflixAppState createState() => _FluflixAppState();
}

class _FluflixAppState extends State<FluflixApp> {
  ThemeMode themeMode = ThemeMode.light;
  late SharedPreferences prefs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setMode();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //truncateDB();
    //print("TB truncated");
  }

  truncateDB() async {
    await deleteDatabase('favorite.db');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return StreamBuilder<bool>(
        initialData: true,
        stream: isLightTheme.stream,
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Fluflix',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: snapshot.data == true ? ThemeMode.dark : ThemeMode.light,
            home: FluflixHome(),
            initialRoute: '/home',
            routes: {
              '/home': (context) => FluflixHome(),
              '/player': (context) => Player(),
              '/category': (context) => Category(),
              //'/detail': (context) => Detail(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/detail':
                  final args =
                      settings.arguments as String; // Retrieve the value.
                  return MaterialPageRoute(
                      builder: (_) => Detail(args)); // Pass it to BarPage.

                default:
                  return null;
              }
            },
          );
        });
  }

  Future<void> setMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = (prefs.getBool("isDark") ?? false) ? false : true;
    print("setMode real isDark:" + isDark.toString());
    isLightTheme.add(isDark);
    print("setmode");
    setState(() {});
  }
}

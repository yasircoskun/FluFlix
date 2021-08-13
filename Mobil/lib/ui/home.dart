import 'dart:io';

import 'package:fluflix/main.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

//widgets
import 'package:fluflix/ui/widgets/category_poster_list.dart';
import 'package:fluflix/ui/widgets/recently_poster_list.dart';
import 'package:fluflix/ui/widgets/search_list.dart';
import 'package:fluflix/ui/widgets/favorites_poster_list.dart';

class FluflixHome extends StatefulWidget {
  FluflixHome();

  @override
  _FluflixHomeState createState() => _FluflixHomeState();
}

class _FluflixHomeState extends State<FluflixHome> {
  late bool isDarkMode;
  late int easterEgg;
  Future<void> toggleTheme() async {
    isDarkMode = !isDarkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //isDarkMode = (prefs.getBool("isDark") ?? false) ? false : true;
    await prefs.setBool("isDark", isDarkMode);
    isDarkMode = (prefs.getBool("isDark") ?? false) ? false : true;
    isLightTheme.add(isDarkMode);
    print(isDarkMode);
    print("toogleTheme isDarkMode:" +
        (prefs.getBool("isDark") == false).toString());
    setSwich();
    setState(() {});
  }

  Future<void> setSwich() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = (prefs.getBool("isDark") ?? false) ? false : true;
    print("setSwich isDarkMode:" + isDarkMode.toString());
    print("setSwich");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSwich();
    easterEgg = 0;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onLongPress: () {
                      easterEgg += 1;
                      if (easterEgg == 7) {
                        easterEgg = 0;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('sisyshell')));
                        print(easterEgg);
                      }
                    },
                    child: Text("Hakkında",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      DefaultCacheManager manager = new DefaultCacheManager();
                      manager.emptyCache();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Ön Bellek Temizlendi")));
                    },
                    child: Text("Ön Belleği Temizle",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Fluflix", style: Theme.of(context).textTheme.bodyText1),
                  Text("v1.0.1"),
                ],
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dark Mode",
                      style: Theme.of(context).textTheme.bodyText1),
                  Switch(
                    onChanged: (bool value) {
                      toggleTheme();
                      isDarkMode = !value;
                    },
                    value: isDarkMode,
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SearchList(),
          FavoritesPosterList(
            title: "Favoriler",
          ),
          RecentlyPosterList(title: "Yeni Diziler"),
          Divider(),

          //CategoryPosterList(title: "kore", type: "Dizi"),
          //CategoryPosterList(title: "netflix", type: "Dizi"),
          //CategoryPosterList(title: "apple-tv", type: "Dizi"),
          //CategoryPosterList(title: "marvel", type: "Dizi"),
          //CategoryPosterList(title: "dc-comics", type: "Dizi"),

          CategoryPosterList(
            title: "Aksiyon",
            type: "Dizi",
            posterFuture: getPostersWithCategory("Aksiyon", "Dizi"),
          ),
          Divider(),
          CategoryPosterList(
              title: "Animasyon",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Animasyon", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Belgesel",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Belgesel", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Bilim Kurgu",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Bilim Kurgu", "Dizi")),
          Divider(),
          //CategoryPosterList(title: "Biyografi", type: "Dizi"),Divider(),
          CategoryPosterList(
              title: "Dram",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Dram", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Fantastik",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Fantastik", "Dizi")),
          Divider(),
          //CategoryPosterList(title: "Gençlik", type: "Dizi"),Divider(),
          CategoryPosterList(
              title: "Gerilim",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Gerilim", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Gizem",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Gizem", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Komedi",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Komedi", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Korku",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Korku", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Macera",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Macera", "Dizi")),
          Divider(),
          //CategoryPosterList(title: "Polisiye", type: "Dizi"),Divider(),
          CategoryPosterList(
              title: "Romantik",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Romantik", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Savaş",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Savaş", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Suç",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Suç", "Dizi")),
          Divider(),
          CategoryPosterList(
              title: "Tarih",
              type: "Dizi",
              posterFuture: getPostersWithCategory("Tarih", "Dizi")),
          Divider(),
          /*
          CategoryPosterList(title: "Aksiyon", type: "Film"),
          CategoryPosterList(title: "Animasyon", type: "Film"),
          CategoryPosterList(title: "Belgesel", type: "Film"),
          CategoryPosterList(title: "Bilim-Kurgu", type: "Film"),
          //CategoryPosterList(title: "Biyografi", type: "Film"),
          CategoryPosterList(title: "Dram", type: "Film"),
          CategoryPosterList(title: "Fantastik", type: "Film"),
          //CategoryPosterList(title: "Gençlik", type: "Film"),
          CategoryPosterList(title: "Gerilim", type: "Film"),
          CategoryPosterList(title: "Gizem", type: "Film"),
          CategoryPosterList(title: "Komedi", type: "Film"),
          CategoryPosterList(title: "Korku", type: "Film"),
          CategoryPosterList(title: "Macera", type: "Film"),
          //CategoryPosterList(title: "Polisiye", type: "Film"),
          CategoryPosterList(title: "Romantik", type: "Film"),
          CategoryPosterList(title: "Savas", type: "Film"),
          CategoryPosterList(title: "Suc", type: "Film"),
          CategoryPosterList(title: "Tarih", type: "Film"),*/
        ],
      ),
    );
  }
}

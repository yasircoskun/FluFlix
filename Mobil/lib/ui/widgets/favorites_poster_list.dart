import 'dart:async';

import 'package:fluflix/scripts/mics.dart';
import 'package:fluflix/scripts/sqlite.dart';
import 'package:fluflix/ui/widgets/poster.dart';
import 'package:flutter/material.dart';

class FavoritesPosterList extends StatefulWidget {
  FavoritesPosterList({required this.title});

  final String title;

  @override
  _FavoritesPosterListState createState() => _FavoritesPosterListState();
}

class _FavoritesPosterListState extends State<FavoritesPosterList> {
  List<Favorite> favList = [];
  List<Widget> posterList = [];
  StreamController<List<Favorite>> favStream = StreamController();
  //late Future<List> future;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavList();
    print(GlobalKey());
  }

  getFavList() async {
    (await FavoriteProvider.db!.rawQuery("Select * From Favorites"))
        .forEach((fav) {
      favList.add(Favorite.fromMap(fav));
    });

    print(favList);

    favStream.add(favList);
    //future = getPostersFavoriteList(favList, posterList);

    /*future.whenComplete(() {
      
      print('End');
    });*/
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    favStream.close();
  }

  @override
  Widget build(BuildContext context) {
    StreamBank.addStream("favStream", favStream);
    print("favStream setted" + favStream.hashCode.toString());
    return favList.isNotEmpty
        ? Column(
            children: [
              Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(
                      "${widget.title}",
                      style: Theme.of(context).textTheme.title,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).iconTheme.color,
                    )
                  ],
                ),
              ),
              Container(
                height: 280.0,
                child: StreamBuilder<List<Favorite>>(
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Favorite>> snapshot) {
                    print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData == null) {
                      print('project snapshot data is: ${snapshot.data}');
                      return Container(
                        child: Text("Hata"),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Poster(
                                  link: snapshot.data![index].url,
                                  url: snapshot.data![index].poster,
                                  title: "")
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  stream: favStream.stream,
                ),
              ),
              Divider()
            ],
          )
        : Container(height: 0);
  }
}

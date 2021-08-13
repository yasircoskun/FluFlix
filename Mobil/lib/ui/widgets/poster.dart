import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluflix/main.dart';
import 'package:fluflix/scripts/mics.dart';
import 'package:fluflix/scripts/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Poster extends StatefulWidget {
  Poster({required this.url, required this.title, required this.link})
      : super();
  bool isFav = true;
  final String url, title, link;

  @override
  _PosterState createState() => _PosterState();
}

class _PosterState extends State<Poster> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ifFaved();
  }

  ifFaved() async {
    int len = (await FavoriteProvider.db!.rawQuery(
            "Select * From Favorites Where url = '" + widget.link + "'"))
        .length;
    print('len: ' + len.toString());
    if (len > 0) {
      widget.isFav = true;
    } else {
      widget.isFav = false;
    }
    setState(() {
      widget.isFav = widget.isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Tapped on ${widget.title} >> ${widget.link}");
        Navigator.pushNamed(context, '/detail',
            arguments: widget.link + "---" + widget.url);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                  height: 280,
                  width: 200,
                  child: Center(child: CircularProgressIndicator())),
              imageUrl: 'https://api.allorigins.win/raw?url=${widget.url}',
              height: 280,
            ),
          ),
          Positioned(
              top: 4,
              right: 6,
              child: Visibility(
                visible: widget.title == "" ? true : false,
                child: InkWell(
                  onTap: () async {
                    widget.isFav = widget.isFav ? false : true;
                    setState(() {});
                    if (widget.isFav) {
                      (provider.insert(Favorite.fromMap(
                              {'url': widget.link, 'poster': widget.url})))
                          .then((value) async {
                        print("stream is closed:");
                        print(StreamBank.getStream("favStream")!.isPaused);
                        var allFav = await provider.getAll();
                        StreamBank.getStream("favStream")!.add(allFav);
                        ifFaved();
                      });
                    } else {
                      (await FavoriteProvider.db!
                          .rawQuery("Select * From Favorites Where url = '" +
                              widget.link +
                              "'")
                          .then((value) async {
                        value.forEach((fav) {
                          print("stream is closed:");
                          print(StreamBank.getStream("favStream")!.isPaused);
                          print(Favorite.fromMap(fav).poster);

                          provider.delete(Favorite.fromMap(fav).id);
                        });
                        var allFav = await provider.getAll();
                        print(allFav);
                        print(StreamBank.getStream("favStream"));
                        StreamBank.getStream("favStream")!.add(allFav);
                        ifFaved();
                      }));
                    }
                    setState(() {});
                  },
                  child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                      child: widget.isFav
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red[800],
                            )
                          : Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red[800],
                            )),
                ),
              ))
        ]),
      ),
    );
  }
}

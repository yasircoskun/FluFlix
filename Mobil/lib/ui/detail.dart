import 'dart:async';

import 'package:fluflix/scripts/imdb_scarper.dart';
import 'package:fluflix/scripts/mics.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';
import 'package:fluflix/main.dart';
import 'package:fluflix/scripts/sqlite.dart';
import 'package:fluflix/ui/widgets/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class Detail extends StatefulWidget {
  final String args;
  Detail(this.args);

  @override
  DetailState createState() => DetailState(args);
}

class DetailState extends State<Detail> {
  DetailState(this.args);
  final String args;
  final keyController = TextEditingController();
  late String link;
  bool isFav = false;
  int page = 1;
  PassByValueVarX lastPageNum = PassByValueVarX();

  ScrollController _scrollController = ScrollController();

  var title = "-";
  var country = "-";
  var length = "-";
  var language = "-";
  var categories = "-";
  var description = "-";
  var year = "-";

  Future<void> searchResultFuture = Future.wait([]);
  String posterLink = "";
  double searchResultHeight = 0;
  late StreamController<String> stream;

  late imdbDataModel data;
  late PassByValueimdbDataModel varX;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("detail init");
    stream = new BehaviorSubject();

    //stream.add(resultList);
  }

  ifFaved() async {
    int len = (await FavoriteProvider.db!
            .rawQuery("Select * From Favorites Where url = '" + link + "'"))
        .length;
    print('len: ' + len.toString());
    if (len > 0) {
      isFav = true;
    } else {
      isFav = false;
    }

    setState(() {
      isFav = isFav;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    List<dynamic> argsList = args.toString().split('---');
    link = argsList[0];
    posterLink = argsList[1];
    print(link);
    data = new imdbDataModel();
    data.poster = posterLink;
    varX = new PassByValueimdbDataModel(x: data);
    print(varX);
    title = link.split('/')[link.split('/').length - 2].replaceAll('-', ' ');
    searchResultFuture = searchResultFuture is Object
        ? getPoster(link, varX)
        : searchResultFuture;
    print(varX);

    searchResultFuture.whenComplete(() async {
      //await Future.delayed(Duration(seconds: 1));
      //_scrollController.jumpTo(_scrollController.position.minScrollExtent);
      print("data.poster : " + data.poster.toString());
      print("varX.poster : " + varX.x.poster.toString());
      print(varX.x);
      title = varX.x.title;
      country = varX.x.country;
      length = varX.x.length;
      year = varX.x.year;
      language = varX.x.language;
      description = varX.x.description;
      asyncSetState();
      stream.add(varX.x.poster.toString());
    });
    ifFaved();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> search() async {}

  Future<void> getCategory() async {}

  Future<void> loadMore() async {}

  Future<void> asyncSetState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                transform: Matrix4.translationValues(0.0, 40.0, 0.0),
                child: Stack(
                  children: [
                    Container(
                      transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                      child: Hero(
                        tag: "title",
                        child: ShadowClip(
                          clipper: BottomOvalClipper(),
                          shadow: Shadow(blurRadius: 20.0),
                          child: ClipPath(
                            clipper: BottomOvalClipper(),
                            child: StreamBuilder<String>(
                                stream: stream.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  print(snapshot.connectionState);
                                  if (snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.active) {
                                    print(snapshot.data);
                                    return Image.network(
                                      snapshot.data.toString(),
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                    );
                                  } else {
                                    print(snapshot.data);
                                    print(posterLink);
                                    return Image.network(
                                      'https://api.allorigins.win/raw?url=' +
                                          posterLink,
                                      colorBlendMode: BlendMode.colorBurn,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.contain,
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 0.0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RawMaterialButton(
                          padding: EdgeInsets.all(10.0),
                          elevation: 12.0,
                          onPressed: () {
                            setState(() {
                              Navigator.pushNamed(context, '/player',
                                  arguments: link);
                            });
                          },
                          shape: CircleBorder(),
                          fillColor: Theme.of(context).scaffoldBackgroundColor,
                          child: Icon(
                            Icons.play_arrow,
                            size: 60.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: IconButton(
                        onPressed: () => print('Add to My List'),
                        icon: Icon(Icons.add),
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: IconButton(
                        onPressed: () => print('Share'),
                        icon: Icon(Icons.open_in_new),
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      link.split('/').indexOf('diziler') != -1
                          ? "Dizi"
                          : "Film",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      '',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Dil',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              language.toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Ülke",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              country,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "Süre",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              length,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      child: Text(
                        description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isFav = isFav ? false : true;
                  });
                  if (isFav) {
                    (provider.insert(Favorite.fromMap(
                            {'url': link, 'poster': posterLink})))
                        .then((value) async {
                      print(StreamBank.getStream("favStream"));
                      StreamBank.getStream("favStream")!
                          .add(await provider.getAll());
                    });
                  } else {
                    (await FavoriteProvider.db!
                        .rawQuery("Select * From Favorites Where url = '" +
                            link +
                            "'")
                        .then((value) async {
                      value.forEach(
                          (fav) => {provider.delete(Favorite.fromMap(fav).id)});
                      print(StreamBank.getStream("favStream"));
                      StreamBank.getStream("favStream")!
                          .add(await provider.getAll());
                    }));
                  }
                  setState(() {});
                },
                child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                    child: isFav
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red[900],
                          )
                        : Icon(
                            Icons.favorite_border_outlined,
                            color: Theme.of(context).iconTheme.color,
                          )),
              )),
          Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).iconTheme.color,
                    )),
              ))
        ],
      ),
    );
  }
}

class BottomOvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height * 0.95);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - size.width / 4,
      size.height,
      size.width,
      size.height * 0.95,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomOvalClipper oldClipper) => false;
}

@immutable
class ShadowClip extends StatelessWidget {
  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget child;

  ShadowClip({
    required this.shadow,
    required this.clipper,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
        clipper: this.clipper,
        shadow: this.shadow,
      ),
      child: ClipPath(child: child, clipper: this.clipper),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  _ClipShadowShadowPainter({required this.shadow, required this.clipper});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

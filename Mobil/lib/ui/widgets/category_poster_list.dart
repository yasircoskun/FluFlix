import 'package:flutter/material.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';

//widgets
import 'package:fluflix/ui/widgets/poster.dart';

class CategoryPosterList extends StatefulWidget {
  CategoryPosterList(
      {required this.title, required this.type, required this.posterFuture});

  final String title;
  final String type;
  final Future<List<Poster>> posterFuture;

  @override
  _CategoryPosterListState createState() => _CategoryPosterListState();
}

class _CategoryPosterListState extends State<CategoryPosterList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Category Poster List init : " + widget.title);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Category Poster List Build : " + widget.title);
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            child: InkWell(
              child: Row(
                children: [
                  Text(
                    "${widget.title} " + widget.type + "leri",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/category',
                    arguments: widget.title);
                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yapım Aşamasında')));
              },
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: 0.0),
          height: 280.0,
          child: FutureBuilder(
              builder:
                  (BuildContext context, AsyncSnapshot<List<Poster>> snapshot) {
                if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null) {
                  print('project snapshot data is: ${snapshot.data}');
                  return Container(
                    child: Text("Hata"),
                  );
                }

                return snapshot.hasData
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.length - 1) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/category',
                                    arguments: widget.title);
                                //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yapım Aşamasında')));
                              },
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 100, 20, 100),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.all_inclusive,
                                            size: 50,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          Text(
                                            "Tümünü Görüntüle",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Column(
                            children: <Widget>[snapshot.data![index]],
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
              future: widget
                  .posterFuture //getPostersWithCategory(widget.title, widget.type),
              ),
        ),
      ],
    );
  }
}

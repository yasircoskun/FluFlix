import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';

class RecentlyPosterList extends StatelessWidget {
  const RecentlyPosterList({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text(
                "$title",
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
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
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
                      children: <Widget>[snapshot.data![index]],
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            future: getPosters(),
          ),
        ),
      ],
    );
  }
}

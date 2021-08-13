import 'package:flutter/material.dart';

//widgets
import 'package:fluflix/ui/widgets/poster.dart';

class PosterList extends StatelessWidget {
  const PosterList({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            style: TextStyle(fontSize: 22),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 0.0),
          height: 200.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Poster(
                  url:
                      "https://www.dizigom1.com/wp-content/uploads/2021/05/star-wars-the-bad-batch.jpg",
                  title: "",
                  link: ""),
              Poster(
                  url:
                      "https://www.dizigom1.com/wp-content/uploads/2021/05/the-sons-of-sam-a-descent-into-darkness.jpg",
                  title: "",
                  link: ""),
              Poster(
                  url:
                      "https://www.dizigom1.com/wp-content/uploads/2021/05/the-mosquito-coast.jpg",
                  title: "",
                  link: ""),
              Poster(
                  url:
                      "https://www.dizigom1.com/wp-content/uploads/2021/05/the-innocent.jpg",
                  title: "",
                  link: ""),
              Poster(
                  url:
                      "https://www.dizigom1.com/wp-content/uploads/2021/04/yasuke.jpg",
                  title: "",
                  link: ""),
            ],
          ),
        ),
      ],
    );
  }
}

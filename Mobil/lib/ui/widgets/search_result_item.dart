import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  const SearchResultItem(
      {required this.url,
      required this.title,
      required this.link,
      required this.summary});

  final String url, title, link, summary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Tapped on $title >> $link");
        Navigator.pushNamed(context, '/detail', arguments: link + "---" + url);
      },
      child: Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://api.allorigins.win/raw?url=$url',
                      ),
                    )),
                Expanded(
                    child: Container(
                  height: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$title",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                              text: "\n$summary",
                              style: Theme.of(context).textTheme.caption),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

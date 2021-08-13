import 'package:fluflix/main.dart';
import 'package:flutter/material.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchList extends StatefulWidget {
  SearchList();

  @override
  SearchListState createState() => SearchListState();
}

class SearchListState extends State<SearchList> {
  SearchListState();
  final keyController = TextEditingController();

  Future<List> _result = getSearch("");
  double searchResultHeight = 0;

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

  Future<void> search() async {
    var result = getSearch(keyController.text);
    setState(() {
      _result = result;
      searchResultHeight = MediaQuery.of(context).size.height - 49;
      print(_result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).highlightColor, width: 1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () async {
                    if (searchResultHeight == 0) {
                      Scaffold.of(context).openDrawer();
                    } else {
                      searchResultHeight = 0;
                      setState(() {});
                    }
                  },
                  child: searchResultHeight == 0
                      ? Icon(Icons.menu,
                          color: Theme.of(context).iconTheme.color)
                      : Icon(Icons.arrow_back_sharp,
                          color: Theme.of(context).iconTheme.color)),
              Container(
                width: MediaQuery.of(context).size.width - 80,
                margin: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    SystemChrome.setEnabledSystemUIOverlays([]);
                    search();
                  },
                  controller: keyController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodyText1,
                      hintText: "Ara"),
                ),
              ),
              InkWell(
                  onTap: () async {
                    search();
                  },
                  child: Icon(Icons.search,
                      color: Theme.of(context).iconTheme.color)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 0.0),
          height: searchResultHeight,
          child: FutureBuilder(
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.none &&
                  snapshot.hasData == null) {
                print('project snapshot data is: ${snapshot.data}');
                return Container(
                  child: Text("Hata"),
                );
              }

              return snapshot.hasData
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[snapshot.data![index], Divider()],
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
            future: _result,
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:fluflix/scripts/mics.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';
import 'package:fluflix/ui/widgets/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class Category extends StatefulWidget {
  Category();

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  CategoryState();
  final keyController = TextEditingController();
  late String category;
  int page = 1;
  PassByValueVarX lastPageNum = PassByValueVarX();

  ScrollController _scrollController = ScrollController();
  var _result;
  late Future<void> searchResultFuture;
  List<SearchResultItem> resultList = [];
  double searchResultHeight = 0;
  late StreamController<List<SearchResultItem>> stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = new BehaviorSubject();
    stream.add(resultList);
  }

  @override
  void dispose() {
    keyController.dispose();
    super.dispose();
  }

  Future<void> search() async {
    var result = getSearchInCat(
        keyController.text, category, page, resultList, lastPageNum);
    setState(() {
      _result = result;
      searchResultHeight = MediaQuery.of(context).size.height - 65;
      print(_result);
    });
  }

  Future<void> getCategory() async {
    print("cat : " + category);

    var result = getSearchInCat("", category, page, resultList, lastPageNum);
    setState(() {
      _result = result;
      searchResultHeight = MediaQuery.of(context).size.height - 65;
      print(_result);
    });
  }

  Future<void> loadMore() async {
    print('scroll end');
    print('page : ' + page.toString());
    print('LAst : ' + lastPageNum.x.toString());
    if (lastPageNum.x != null && page <= lastPageNum.x) {
      print(page);
      var result = getSearchInCat("", category, page, resultList, lastPageNum);
      setState(() {
        _result = result;
        searchResultHeight = MediaQuery.of(context).size.height - 65;
        print(_result);
      });
    }
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
    category = ModalRoute.of(context)!.settings.arguments.toString();
    searchResultFuture = getCategory();
    searchResultFuture.whenComplete(() async {
      await Future.delayed(Duration(seconds: 1));

      //_scrollController.jumpTo(_scrollController.position.minScrollExtent);
      stream.add(resultList);
    });
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
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
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: keyController,
                    style: Theme.of(context).textTheme.subtitle1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: Theme.of(context).textTheme.subtitle1,
                        hintText: category + " içinde ara"),
                  ),
                ),
                InkWell(
                    onTap: () {
                      search();
                    },
                    child: Icon(Icons.search,
                        color: Theme.of(context).iconTheme.color)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 0.0),
              height: searchResultHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    page += 1;
                    loadMore();
                  }
                  return true;
                },
                child: StreamBuilder(
                  builder:
                      (context, AsyncSnapshot<List<SearchResultItem>> snap) {
                    return snap.hasData
                        ? ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snap.data!.length,
                            itemBuilder: (context, index) {
                              print(snap.data![index]);
                              return Column(
                                children: <Widget>[
                                  snap.data![index],
                                  Divider()
                                ],
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                  stream: stream.stream,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

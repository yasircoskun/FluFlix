import 'dart:convert';

import 'package:fluflix/scripts/sqlite.dart';
import 'package:flutter/cupertino.dart' hide Element;
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:js_packer/js_packer.dart';

import 'package:fluflix/ui/widgets/poster.dart';
import 'package:fluflix/ui/widgets/episode_item.dart';
import 'package:fluflix/ui/widgets/search_result_item.dart';

import 'package:fluflix/scripts/mics.dart';

//https://www.dizigom1.com/dizi-arsivi/?filtrele=imdb&sirala=DESC&yil=0&imdb=&kelime=&tur=Aksiyon

Future<List<Poster>> getPostersWithCategory(String cat, String type) async {
  // Make API call to Hackernews homepage
  var client = Client();
  if (type == "Dizi") {
    List<String> specialCats = [
      'kore',
      'netflix',
      'apple-tv',
      'marvel',
      'dc-comics'
    ];
    Response response;
    if (specialCats.contains(cat)) {
      response = await client
          .get(Uri.parse('https://www.dizigom1.com/' + cat + '-dizileri/'));
    } else {
      response = await client.get(Uri.parse(
          'https://www.dizigom1.com/dizi-arsivi/?filtrele=imdb&sirala=DESC&yil=0&imdb=&kelime=&tur=' +
              cat));
    }

    // Use html parser
    var document = parse(response.body);

    List<Element> links =
        document.querySelectorAll('.single-item .cat-title a');

    List<Element> images = document.querySelectorAll('.single-item img');
    List<Element> texts = document.querySelectorAll('.single-item img');
    List<Poster> widgetList = [];

    //for (var image in images) {
    for (var i = 0; i < images.length; i++) {
      widgetList.add(Poster(
          url: images[i].attributes['src'].toString(),
          title: images[i].attributes['alt'].toString(),
          link: links[i].attributes['href'].toString()));
    }

    print(widgetList);

    return widgetList;
  } else {
    print("Film");
    Response response = await client
        .get(Uri.parse('https://www.dizigom1.com/film-tur/' + cat + '/'));

    // Use html parser
    var document = parse(response.body);
    print(document.querySelectorAll('img.lazy')[0].attributes['data-src']);
    List<Element> links = document.querySelectorAll('#film-ismi a');

    List<Element> images = document.querySelectorAll('img.lazy');
    List<Poster> widgetList = [];

    //for (var image in images) {
    for (var i = 0; i < images.length; i++) {
      widgetList.add(Poster(
          url: images[i].attributes['data-src'].toString(),
          title: images[i].attributes['alt'].toString(),
          link: links[i].attributes['href'].toString()));
    }

    print(widgetList);

    return widgetList;
  }
}

Future<List> getPosters() async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = await client.get(Uri.parse(
      'https://www.dizigom1.com/dizi-arsivi/?filtrele=tarih&sirala=DESC&yil=&imdb=&kelime='));

  // Use html parser
  var document = parse(response.body);

  List<Element> links = document.querySelectorAll('.single-item .cat-title a');

  List<Element> images = document.querySelectorAll('.single-item img');
  List<Widget> widgetList = [];

  //for (var image in images) {
  for (var i = 0; i < images.length; i++) {
    widgetList.add(Poster(
        url: images[i].attributes['src'].toString(),
        title: images[i].attributes['alt'].toString(),
        link: links[i].attributes['href'].toString()));
  }

  print(widgetList);

  return widgetList;
}

Future<List> getPostersFavoriteList(
    List<Favorite> favList, List<Widget> widgetList) async {
  // Make API call to Hackernews homepage
  var client = Client();
  widgetList.clear();
  favList.forEach((element) async {
    Response response = await client.get(Uri.parse(element.url));
    print("fav poster in > " + element.url);
    // Use html parser
    var document = parse(response.body);

    Element image = document.querySelectorAll('#icerikcat img')[0];
    print(image.attributes['data-src'].toString());
    widgetList.add(Poster(
        url: image.attributes['data-src'].toString(),
        title: image.attributes['alt'].toString(),
        link: element.url));
  });

  print("completed");

  return widgetList;
}

Future<List> getSearch(String keyword) async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response =
      await client.get(Uri.parse('https://www.dizigom1.com/?s=' + keyword));
  /*await client.get(
      'https://www.dizigom1.com/dizi-arsivi/?filtrele=tarih&sirala=DESC&yil=&imdb=&kelime=' +
          keyword);*/

  // Use html parser
  var document = parse(response.body);

  List<Element> links = document.querySelectorAll(
      '.cat-container .cat-title a'); //document.querySelectorAll('.single-item .cat-title a');
  List<Element> summaries = document.querySelectorAll(
      '.cat-container-in'); //document.querySelectorAll('.single-item #cat_ozet');

  List<Element> images = document.querySelectorAll(
      '.cat-img img'); //document.querySelectorAll('.single-item img');
  List<Widget> widgetList = [];

  //for (var image in images) {
  for (var i = 0; i < images.length; i++) {
    widgetList.add(SearchResultItem(
      url: images[i].attributes['src'].toString(),
      title: links[i].text, //images[i].attributes['alt'],
      link: links[i].attributes['href'].toString(),
      summary: summaries[i].text,
    ));
  }

  print(widgetList);

  return widgetList;
}

Future getSearchInCat(String keyword, String cat, int page,
    List<SearchResultItem> resultList, PassByValueVarX intX) async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response =
      /* await client.get('https://www.dizigom1.com/?s=' + keyword);*/
      await client.get(Uri.parse('https://www.dizigom1.com/dizi-arsivi/page/' +
          page.toString() +
          '/?filtrele=tarih&sirala=DESC&yil=&imdb=&kelime=' +
          keyword +
          '&tur=' +
          cat));

  // Use html parser

  var document = parse(response.body);

  List<Element> links =
      /* document.querySelectorAll(
      '.cat-container .cat-title a'); */
      document.querySelectorAll('.single-item .cat-title a');
  List<Element> summaries =
      /*document.querySelectorAll(
      '.cat-container-in'); */
      document.querySelectorAll('.single-item #cat_ozet');

  List<Element> images = /*document.querySelectorAll(
      '.cat-img img'); */
      document.querySelectorAll('.single-item img');
  if (document
          .querySelectorAll('.page-numbers')[
              document.querySelectorAll('.page-numbers').length - 1]
          .text
          .indexOf("»") ==
      -1) {
    intX.x = int.parse(document
        .querySelectorAll('.page-numbers')[
            document.querySelectorAll('.page-numbers').length - 1]
        .text);
  } else {
    intX.x = int.parse(document
        .querySelectorAll('.page-numbers')[
            document.querySelectorAll('.page-numbers').length - 2]
        .text);
  }
  print("LAst in scarper " + intX.x.toString());

  List<Widget> widgetList = [];

  //for (var image in images) {
  for (var i = 0; i < images.length; i++) {
    widgetList.add(SearchResultItem(
      url: images[i].attributes['src'].toString(),
      title: links[i].text, //images[i].attributes['alt'],
      link: links[i].attributes['href'].toString(),
      summary: summaries[i].text,
    ));

    resultList.add(SearchResultItem(
      url: images[i].attributes['src'].toString(),
      title: links[i].text, //images[i].attributes['alt'],
      link: links[i].attributes['href'].toString(),
      summary: summaries[i].text,
    ));
  }

  print(widgetList);

  return widgetList;
}

Future getEpisodes(String link, var parent, var videoPlayerController,
    List<EpisodeItem> episodeListCallback) async {
  // Make API call to Hackernews homepage
  if (link.indexOf('film-izle') != -1) {
    List<Widget> widgetList = [];

    widgetList.add(EpisodeItem(
        text: link,
        link: link,
        changeVideo: parent,
        selected: false,
        videoPlayerController: videoPlayerController));

    if (episodeListCallback.length != 1) {
      episodeListCallback.add(EpisodeItem(
          text: link,
          link: link,
          changeVideo: parent,
          selected: false,
          videoPlayerController: videoPlayerController));
    }

    return widgetList;
  }
  var client = Client();
  Response response = await client.get(Uri.parse(link));

  // Use html parser
  var document = parse(response.body);

  List<Element> episodes =
      document.querySelectorAll('.custom-scrollbarxxx .baslik');
  //List<Element> episodeNames = document.querySelectorAll('.custom-scrollbarxxx .bolumismi');
  List<Element> links = document
      .querySelectorAll('.custom-scrollbarxxx a')
      .where((x) => x.className != 'wpfp-link')
      .toList();
  List<Widget> widgetList = [];

  //for (var image in images) {
  for (var i = 0; i < episodes.length; i++) {
    widgetList.add(EpisodeItem(
        text: episodes[i].text,
        link: links[i].attributes['href'].toString(),
        changeVideo: parent,
        selected: false,
        videoPlayerController: videoPlayerController));

    if (episodeListCallback.length != episodes.length) {
      episodeListCallback.add(EpisodeItem(
          text: episodes[i].text,
          link: links[i].attributes['href'].toString(),
          changeVideo: parent,
          selected: false,
          videoPlayerController: videoPlayerController));
    }
  }

  print(widgetList);

  return widgetList;
}

Future getVideo(String link) async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = await client.get(Uri.parse(link));

  var document = parse(response.body);

  if (link.indexOf('film-izle') != -1) {
    List<Element> iframes = document.querySelectorAll('iframe');
    String iframeSrc = iframes[0].attributes['src'].toString();
    print(iframeSrc);
    response = await client.get(
      Uri.parse(iframeSrc.replaceAll('https', 'http')),
      headers: {'Referer': 'https://www.dizigom1.com'},
    );
    print(response.body);
    document = parse(response.body);
    print(document.querySelectorAll('script'));
    List<Element> scripts = document.querySelectorAll('script');
    JSPacker jsPacker = JSPacker(scripts[scripts.length - 3].text);
    print("JS");
    print(scripts[scripts.length - 3].text);
    var unpacked = jsPacker.unpack();
    print(unpacked);
    var videoLink = unpacked!
        .substring(unpacked.indexOf('http'),
            unpacked.indexOf('"', unpacked.indexOf('ygve')))
        .replaceAll('\\', '');
    print("video link: " + videoLink);
    return videoLink;
  }

  ///api.php?action=get_video&id=postID
  List<Element> curLink = document.querySelectorAll('.watchlater-link');
  print(curLink);
  var postID = curLink[0].attributes['href'].toString().substring(
      curLink[0].attributes['href'].toString().lastIndexOf('=') + 1,
      curLink[0].attributes['href'].toString().length);
  print(postID);
  response = await client.get(
    Uri.parse("https://www.dizigom1.com/api.php?action=get_video&id=" + postID),
    headers: {'Referer': 'https://www.dizigom1.com'},
  );

  var iframeSrc = new String.fromCharCodes(base64Decode(response.body));
  iframeSrc = iframeSrc.substring(
      iframeSrc.indexOf('src="') + 5, iframeSrc.indexOf('.mp4') + 4);
  print(iframeSrc);
  /*
  https > http
  E/flutter (14308): [ERROR:flutter/lib/ui/ui_dart_state.cc(199)] Unhandled Exception: HandshakeException: Handshake error in client (OS Error:
  E/flutter (14308): 	CERTIFICATE_VERIFY_FAILED: certificate has expired(handshake.cc:359))
   */
  response = await client.get(
    Uri.parse(iframeSrc.replaceAll('https', 'http')),
    headers: {'Referer': 'https://www.dizigom1.com'},
  );
  print(response.body);
//  print( getJavascriptRuntime().evaluate("btoa(" + response.body + ")").stringResult);
  // Use html parser
  document = parse(response.body);
  print(document.querySelectorAll('script'));
  List<Element> scripts = document.querySelectorAll('script');
  JSPacker jsPacker = JSPacker(scripts[scripts.length - 3].text);
  print("JS");
  print(scripts[scripts.length - 3].text);
  var unpacked = jsPacker.unpack();
  print(unpacked);
  var videoLink = unpacked
      .toString()
      .substring(unpacked.toString().indexOf('http'),
          unpacked.toString().indexOf('"', unpacked.toString().indexOf('ygve')))
      .replaceAll('\\', '');
  print("video link: " + videoLink);
  return videoLink;
}

/*
import 'dart:convert';

import 'package:dizitter/main.dart';
import 'package:flutter/cupertino.dart' hide Element;
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

List<Widget> getPosters() {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = client.get('https://dizigom1.com') as Response;

  // Use html parser
  var document = parse(response.body);
  List<Element> images = document.querySelectorAll('.single-item > img');
  List widgetList = List<Widget>();

  for (var image in images) {
    widgetList.add(Poster(url: image.attributes['src']));
  }

* {
      'title': image.attributes['alt'],
      'src': image.attributes['src'],
    }
*
  return widgetList;
}*/

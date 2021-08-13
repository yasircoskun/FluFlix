import 'package:fluflix/scripts/mics.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

var en = [
  'English',
  'Turkish',
  'Spanish',
  'Danish',
  'Afghan',
  'Albenian',
  'Spanish',
  'English',
  'Russian',
  'German',
  'Spanish',
  'Bosnian',
  'Portuguese',
  'Bulgarian',
  'Cambodian',
  'English',
  'Milliyet: Chilean',
  'Chinese',
  'Spanish',
  'Spanish',
  'Crotian',
  'Spanish',
  'Spanish',
  'Spanish',
  'Arabic',
  'Ülke: Spanish',
  'Estonian',
  'Amharic',
  'Finnish',
  'Georgian',
  'German',
  'Greek',
  'Spanish',
  'Haitian',
  'Hungarian',
  'Indonesian',
  'Iranian – Persian',
  'Iraqi',
  'Irish – Erse',
  'Hebrew',
  'Italian',
  'Japanese',
  'English',
  'Arabic',
  'Korean',
  'Laotian',
  'Latvian',
  'Lithuanian',
  'Malay',
  'Spanish',
  'Dutch',
  'English',
  'Spanish',
  'Norvegian – Norse',
  'Arabic',
  'Spanish',
  'Spanish',
  'Spanish',
  'Tagalog',
  'Polish',
  'Portuguese',
  'Spanish',
  'Romanian',
  'Russian',
  'Arabic',
  'Scotch',
  'Slovak',
  'Swedish',
  'Arabic',
  'Chinese',
  'Thai',
  'Ukrainian',
  'English',
  'Spanish',
  'Vietnamese'
];
var tr = [
  'İngilizce',
  'Türkçe',
  'İspanyolca',
  'Danimarkaca',
  'Afganca',
  'Arnavutça',
  'İspanyolca',
  'İngilizce',
  'Rusça',
  'Almanca',
  'İspanyolca',
  'Boşnakça',
  'Portekizce',
  'Bulgarca',
  'Kamboçyaca',
  'İngilizce',
  'Şilili',
  'Çince',
  'İspanyolca]',
  'İspanyolca',
  'Hırvatça',
  'İspanyolca',
  'İspanyolca',
  'İspanyolca',
  'Arapça',
  'İspanyolca',
  'Estonca',
  'Habeşce',
  'Fince',
  'Gürcüce',
  'Almanca',
  'Yunanca',
  'İspanyolca',
  'Haitice',
  'Macarca',
  'Endonezce',
  'Farsça',
  'Irak Arapçası',
  'İrlandaca',
  'İbranice',
  'İtalyanca',
  'Japonca',
  'İngilizce',
  'Arapça',
  'Korece',
  'Laosça',
  'Letonca',
  'Litvanyaca',
  'Malayca',
  'İspanyolca',
  'Hollandaca',
  'İngilizce',
  'İspanyolca',
  'Norveçce',
  'Arapça',
  'İspanyolca',
  'İspanyolca',
  'İspanyolca',
  'Filipince',
  'Lehçe',
  'Portekizce',
  'İspanyolca',
  'Romence',
  'Rusça',
  'Arapça',
  'İskoçca',
  'Slovakça',
  'İsveçce',
  'Arapça',
  'Çince',
  'Tay dili',
  'Ukraynaca',
  'İngilizce',
  'İspanyolca',
  'Vietnamca'
];

Map<String, String> en_to_tr = Map.fromIterables(en, tr);

Future<String> getPoster(link, PassByValueimdbDataModel varX) async {
  // Make API call to Hackernews homepage

  var client = Client();
  Response response = await client.get(Uri.parse(link));

  // Use html parser
  var document = parse(response.body);

  if (link.split('/').indexOf('diziler') != -1) {
    varX.x.description =
        document.querySelectorAll('#icerikcatright')[0].firstChild!.text!;
  } else {
    varX.x.description = document.querySelectorAll('#film-aciklama')[0].text;
  }

  print(varX.x.description);
  var name = link.split('/')[link.split('/').length - 2];

  print('https://www.imdb.com/find?q=' + name + '&s=tt&ttype=tv&ref_=fn_tv');

  response = await client.get(Uri.parse(
      'https://www.imdb.com/find?q=' + name + '&s=tt&ttype=tv&ref_=fn_tv'));

  // Use html parser
  document = parse(response.body);

  List<Element> searchResult = document.querySelectorAll('.result_text a');

  if (searchResult.length > 0) {
    print("imdb page founded");
    //varX.x.country = document.querySelectorAll('#titleDetails a')[2].text;

    Element link = searchResult[0];
    print(link.attributes);
    response = await client.get(Uri.parse(
        'https://www.imdb.com/' + link.attributes['href'].toString()));

    varX.x.title = link.text;
    // Use html parser
    document = parse(response.body);

    String details = document.querySelectorAll('#titleDetails')[0].text;
    print(details);

    ["Country", "Runtime", "Language"].forEach((areaStr) {
      RegExp regExp4Details = new RegExp(
        r"/" + areaStr + ":[A-Za-z0-9\ \t]+/gmi",
        caseSensitive: false,
        multiLine: true,
      );

      var strData = regExp4Details
          .firstMatch(details)
          .toString()
          .replaceAll(areaStr + ": ", "");

      strData = details
          .substring(
              details.indexOf(areaStr),
              details.indexOf(
                  '\n', 1 + details.indexOf('\n', details.indexOf(areaStr))))
          .trim()
          .replaceAll(RegExp(r'' + areaStr + ':'), "")
          .trim();
      print(areaStr + " : " + strData);
      switch (areaStr) {
        case "Country":
          varX.x.country = strData;
          break;
        case "Runtime":
          varX.x.length = strData.replaceAll("min", "dk");
          break;
        case "Language":
          varX.x.language =
              (en_to_tr.containsKey(strData) ? en_to_tr[strData] : strData)!;
          break;
        case "Release Date":
          varX.x.year = strData.split(' ').last;
          break;
        default:
      }
    });

    Element bigPosterLink = document.querySelectorAll('.poster a')[0];

    response = await client.get(Uri.parse(
        'https://www.imdb.com/' + bigPosterLink.attributes['href'].toString()));

    String imageId = bigPosterLink.attributes['href']
        .toString()
        .split('/')[
            bigPosterLink.attributes['href'].toString().split('/').length - 1]
        .split('?')[0];
    // Use html parser
    print(imageId);
    document = parse(response.body);

    Element posterImg = document
        .querySelectorAll('img')
        .where((x) => x.attributes['data-image-id'] == imageId + '-curr')
        .first;

    print("big poster link : " + posterImg.attributes['src'].toString());
    varX.x.poster = posterImg.attributes['src'].toString();
    return posterImg.attributes['src'].toString();
  }

  return "";
}

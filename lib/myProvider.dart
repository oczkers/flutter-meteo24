import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charset_converter/charset_converter.dart';

final regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?
final regex_comment = RegExp(r'[\s\S]*>\s{2}([\s\S]*?)\s<\/div>');

final cities_all = {
  // cityname: [row, col]
  'Warszawa': [406, 250],
  'Kraków': [466, 232],
  'Łódź': [418, 223],
  'Wrocław': [436, 181],
  'Poznań': [400, 180],
  'Gdańsk': [346, 210],
  'Szczecin': [370, 142],
  'Bydgoszcz': [381, 199],
  'Lublin': [432, 277],
  'Białystok': [379, 285],
  // ^ top 10 ^
  'Gorzów Wielkopolski': [390, 152],
  'Katowice': [461, 215],
  'Kielce': [443, 244],
  'Olsztyn': [363, 240],
  'Opole': [449, 196],
  'Rzeszów': [465, 269],
  'Toruń': [383, 209],
  'Zielona Góra': [412, 155],
};

String lang = 'pl';

class MyProvider with ChangeNotifier {
  // TODO?: save last graph on disk
  String cityname = 'Warszawa';
  String url_graph = 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl'; // default value
  String comment = '';
  var cities = cities_all;
  SharedPreferences _data;

  MyProvider() {
    init();
  }

  Future init() async {
    this._data = await SharedPreferences.getInstance();
    this.cityname = this._data.getString('cityname') ?? this.cityname; // refactor
    this.comment = await getComment();
  }

  void setCity(String cityname) async {
    this.cityname = cityname;
    this._data.setString('cityname', cityname);
    this.url_graph = await urlGraph(cityname);
    this.comment = await getComment();
    notifyListeners();
  }

  bool selected(String cityname) {
    return cityname == this.cityname;
  }
}

Future<String> urlGraph(String cityname) async {
  // TODO: validate cityname, return False/None
  // get lastest valid fulldate
  http.Response rc = await http.get('https://www.meteo.pl/meteorogram_um_js.php'); // TODO: validate response status
  String fulldate = regex_fulldate.firstMatch(rc.body).group(1); // TODO: catch exceptions/validate response
  int row = cities_all[cityname][0];
  int col = cities_all[cityname][1];
  return 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$fulldate&row=$row&col=$col&lang=$lang'; // what is ntype?
}

Future<String> getComment() async {
  // TODO: fix charset/encoding https://pub.dev/packages/charset_converter or some other library
  http.Response rc = await http.get('https://www.meteo.pl/komentarze/index1.php');
  String rcc = await CharsetConverter.decode('ISO-8859-2', rc.bodyBytes);
  rcc = rcc.replaceAll('<P> ', '\n\n');
  rcc = rcc.replaceAll('&#8211;', '-');
  String comment = regex_comment.firstMatch(rcc).group(1);
  print(comment);
  return comment;
}

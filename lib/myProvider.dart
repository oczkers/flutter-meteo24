import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?

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
  String url_graph = 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl'; // default value
  String cityname = 'Warszawa'; // default value
  String pagename = 'Warszawa';
  String app_title = 'Meteo24 - Warszawa';
  var cities = cities_all;

  // String get getUrlGraph => _url_graph; // getter

  // setter
  void setCity(String cityname) async {
    this.pagename = cityname;
    this.cityname = cityname;
    this.app_title = 'Meteo24 - $pagename';
    this.url_graph = await urlGraph(this.cityname, cities[this.cityname][0], cities[this.cityname][1]);
    notifyListeners();
  }

  void displayLegend() {
    // TODO?: merge into setcity
    this.url_graph = 'https://www.meteo.pl/um/metco/leg_um_pl_cbase_256.png';
    this.app_title = 'Meteo24 - Legenda';
    this.pagename = 'legend';
    notifyListeners();
  }

  bool selected(String pagename) {
    if (pagename == this.pagename) {
      return true;
    } else {
      return false;
    }
  }
}

Future<String> urlGraph(String cityname, int row, int col) async {
  // TODO: validate cityname, return False/None
  // get lastest valid fulldate
  http.Response rc = await http.get('https://www.meteo.pl/meteorogram_um_js.php'); // TODO: validate response status
  String fulldate = regex_fulldate.firstMatch(rc.body).group(1); // TODO: catch exceptions/validate response
  return 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$fulldate&row=$row&col=$col&lang=$lang'; // what is ntype?
}

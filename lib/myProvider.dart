import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  String pagename;
  String app_title = 'Meteo24';
  var cities = cities_all;
  SharedPreferences data;

  MyProvider() {
    init();
  }

  void init() async {
    this.data = await SharedPreferences.getInstance();
    setCity(this.data.getString('cityname') ?? 'Warszawa');
  }

  // getter
  String cityname() {
    return this.data.getString('cityname');
  }

  // setter
  void setCity(String cityname) async {
    this.data.setString('cityname', cityname);
    this.pagename = cityname;
    this.app_title = 'Meteo24 - $cityname';
    this.url_graph = await urlGraph(cityname);
    notifyListeners();
  }

  bool selected(String pagename) {
    return pagename == this.pagename;
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

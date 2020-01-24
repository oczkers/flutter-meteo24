import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charset_converter/charset_converter.dart';

final RegExp regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?
final RegExp regex_comment = RegExp(r'<div style="padding: 15px; background-color:#fff; background-color:rgba\(255,255,255,0\.6\); margin:10px; border-radius: 10px;">\s{2}([\s\S]*?)\s<\/div>');

final Map<String, List<int>> cities_all = {
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
  List<String> citiesAll = cities_all.keys.toList();
  List<String> cities = cities_all.keys.toList().sublist(0, 10);
  SharedPreferences _data;

  MyProvider() {
    init();
  }

  Future init() async {
    // TODO?: toast helpers on first run https://pub.dev/packages/toast
    this._data = await SharedPreferences.getInstance();
    // TODO: use setCity instead of duplicating code
    this.cityname = this._data.getString('cityname') ?? this.cityname; // refactor
    this.cities = this._data.getStringList('cities') ?? this.cities; // defaults to first top 10 cities
    this.url_graph = await urlGraph(cityname);
    notifyListeners();
    this.comment = await getComment();
  }

  void setCity(String cityname) async {
    // TODO?: load refresh animation before trying to load image
    this.cityname = cityname;
    this._data.setString('cityname', cityname);
    // move active city to top
    this.cities.remove(cityname);
    this.cities.insert(0, cityname);
    // get grapg
    this.url_graph = await urlGraph(cityname);
    notifyListeners();
    this.comment = await getComment();
  }

  void addCity(String cityname) {
    if (!this.cities.contains(cityname)) {
      // TODO?: remove active cities from list instead of silently ommiting
      this.cities.add(cityname);
      this._data.setStringList('cities', this.cities);
    }
    this.setCity(cityname);
    // notifyListeners();
  }

  void removeCity(String cityname) {
    this.cities.remove(cityname);
    this._data.setStringList('cities', this.cities);
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
  // rcc = rcc.replaceAll('<P> ', '\n\n'); // done by html render
  // rcc = rcc.replaceAll('&#8211;', '-');
  // rcc = rcc.replaceAll('&#8222;', '"'); // this is probably bad coding, TODO: find valid charset
  String comment = regex_comment.firstMatch(rcc).group(1);
  print(comment);
  return comment;
}

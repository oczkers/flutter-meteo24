import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charset_converter/charset_converter.dart';

final RegExp regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?
final RegExp regex_comment = RegExp(r'<div style="padding: 15px; background-color:#fff; background-color:rgba\(255,255,255,0\.6\); margin:10px; border-radius: 10px;">\s{2}([\s\S]*?)\s<\/div>');

final String lang = 'pl';

class Data with ChangeNotifier {
  // TODO?: save last graph on disk
  Map<String, dynamic> cities_all;
  String cityname = 'Warszawa';
  // default value TODO?: load image instead of image url allows easly rendering empty at start, or simply use streams
  String url_graph = 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl';
  String comment;
  List<String> cities;
  List<String> cities_found = [];
  SharedPreferences _data;

  Data() {
    init();
  }

  Future init() async {
    // TODO?: toast helpers on first run https://pub.dev/packages/toast
    // TODO: load after rendered like getComment - this requires saving full citydata instead of just cityname
    this.cities_all = JsonDecoder().convert(await rootBundle.loadString('assets/cities.json'));
    this._data = await SharedPreferences.getInstance();
    // TODO: use setCity instead of duplicating code
    this.cityname = this._data.getString('cityname') ?? this.cityname; // refactor
    this.cities = this._data.getStringList('cities') ?? ['Warszawa', 'Kraków', 'Łódź', 'Wrocław', 'Poznań', 'Gdańsk', 'Szczecin', 'Bydgoszcz', 'Lublin', 'Białystok']; // defaults to top10
    this.url_graph = await this.urlGraph(cityname);
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
    this._data.setStringList('cities', this.cities);
    // get grapg
    this.url_graph = await this.urlGraph(cityname);
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
    if (cityname == this.cityname) {
      // TODO: if city is active (top), change to second and reload graph
      this.setCity(this.cities[1]);
    }
    this.cities.remove(cityname);
    this._data.setStringList('cities', this.cities);
    notifyListeners();
  }

  List<String> searchCity(String letters) {
    // TODO: refactor
    if (letters == '') {
      this.cities_found = this.cities_all.keys.toList();
    } else {
      letters = letters.toLowerCase();
      List<String> cities_found_top = [];
      this.cities_found = [];
      for (String i in this.cities_all.keys) {
        if (i.toLowerCase().contains(letters)) {
          if (i.toLowerCase().substring(0, letters.length) == letters) {
            cities_found_top.add(i);
          } else {
            this.cities_found.add(i);
          }
        }
      }
      cities_found_top.sort();
      cities_found_top.addAll(this.cities_found);
      this.cities_found = cities_found_top;
      // this.cities_found = this.cities_all.keys.toList().where((i) => i.toLowerCase().contains(letters.toLowerCase())).toList();
    }
    notifyListeners();
  }

  bool selected(String cityname) {
    return cityname == this.cityname;
  }

  Future<String> urlGraph(String cityname) async {
    // TODO: validate cityname, return False/None
    // get lastest valid fulldate
    http.Response rc = await http.get('https://www.meteo.pl/meteorogram_um_js.php'); // TODO: validate response status
    String fulldate = regex_fulldate.firstMatch(rc.body).group(1); // TODO: catch exceptions/validate response
    int row = int.parse(cities_all[cityname]['row']); // TODO: convert types on import
    int col = int.parse(this.cities_all[cityname]['col']);
    return 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$fulldate&row=$row&col=$col&lang=$lang'; // what is ntype?
  }
}

Future<String> getComment() async {
  // TODO: fix charset/encoding https://pub.dev/packages/charset_converter or some other library
  http.Response rc = await http.get('https://www.meteo.pl/komentarze/index1.php');
  String rcc = await CharsetConverter.decode('ISO-8859-2', rc.bodyBytes);
  // rcc = rcc.replaceAll('<P> ', '\n\n'); // done by html render
  // rcc = rcc.replaceAll('&#8211;', '-');
  // rcc = rcc.replaceAll('&#8222;', '"'); // this is probably bad coding, TODO: find valid charset
  String comment = regex_comment.firstMatch(rcc).group(1);
  return comment;
}

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

RegExp regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?

String lang = 'en';

class MyProvider with ChangeNotifier {
  String url_graph = 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl'; // default value
  String cityname = 'Warsaw'; // default value
  var cities = {
    // cityname: [row, col]
    'Warsaw': [406, 250],
    'Cracow': [466, 232],
  };

  // String get getUrlGraph => _url_graph; // getter

  // setter
  void setCity(String cityname) async {
    this.cityname = cityname;
    this.url_graph = await urlGraph(cityname, cities[cityname][0], cities[cityname][1]);
    notifyListeners();
  }
}

Future<String> urlGraph(String cityname, int row, int col) async {
  // TODO: validate cityname, return False/None
  // get lastest valid fulldate
  http.Response rc = await http.get('https://www.meteo.pl/meteorogram_um_js.php'); // TODO: validate response status
  String fulldate = regex_fulldate.firstMatch(rc.body).group(1); // TODO: catch exceptions/validate response
  return 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$fulldate&row=$row&col=$col&lang=$lang'; // what is ntype?
}

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

RegExp regex_fulldate = RegExp(r'var UM_FULLDATE="([0-9]{10})";'); // final?

var cities = {
  // cityname: [row, col]
  'Warsaw': [406, 250],
  'Cracow': [466, 232],
};

String lang = 'en';

class MyProvider with ChangeNotifier {
  String _param = 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl'; // default value
  String _cityname = 'Warsaw'; // default value

  String get getParam => _param; // getter

  // setter
  void setParam(String cityname) async {
    // get latest valid fulldate
    _cityname = cityname;
    _param = await urlGraph(cityname);
    notifyListeners();
  }
}

Future<String> urlGraph(String cityname) async {
  // TODO: validate cityname, return False/None
  // get fulldate
  http.Response rc = await http.get('https://www.meteo.pl/meteorogram_um_js.php'); // TODO: validate response status
  String fulldate = regex_fulldate.firstMatch(rc.body).group(1); // TODO: catch exceptions/validate response
  int row = cities[cityname][0];
  int col = cities[cityname][1];
  return 'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=$fulldate&row=$row&col=$col&lang=$lang'; // what is ntype?
}

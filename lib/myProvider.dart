import 'package:flutter/foundation.dart';

class MyProvider with ChangeNotifier {
  String _param =
      'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl';
  String get getParam => _param; // getter

  // setter
  void setParam(String data) {
    _param = data;
    notifyListeners();
  }
}

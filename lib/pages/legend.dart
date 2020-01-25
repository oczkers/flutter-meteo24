import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class LegendPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Legenda'),
          ),
          body: Center(
            child: Image.network('https://www.meteo.pl/um/metco/leg_um_pl_cbase_256.png'),
          ),
        );
      },
    );
  }
}

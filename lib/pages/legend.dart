import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';

class LegendPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Meteo24 - Legenda'),
          ),
          body: Center(
            child: Image.network('https://www.meteo.pl/um/metco/leg_um_pl_cbase_256.png'),
          ),
        );
      },
    );
  }
}

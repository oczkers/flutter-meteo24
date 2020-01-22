import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';

import 'menubar.dart';

// city graph
// TODO: RefreshIndicator - swipe to refresh
class InitPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Meteo24 - ${myProvider.cityname}'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    myProvider.setCity(myProvider.cityname);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings), // add settings, licenses etc.
                  // onPressed: () {},
                ),
              ],
            ),
            drawer: MenuDrawer(),
            body: Center(
              child: Image.network(myProvider.url_graph),
            ));
      },
    );
  }
}

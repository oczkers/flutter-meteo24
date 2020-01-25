import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../routes.gr.dart';
import 'menubar.dart';

// city graph
// TODO: RefreshIndicator - swipe to refresh
class InitPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(data.cityname),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  data.searchCity(''); // remove old searches
                  Router.navigator.pushNamed(Router.addcityPage);
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  data.setCity(data.cityname);
                },
              ),
              IconButton(
                icon: Icon(Icons.settings), // add settings, licenses etc.
                // onPressed: () {
                //   Router.navigator.pushNamed(Router.settingsPage);
                // },
              ),
            ],
          ),
          drawer: MenuDrawer(),
          body: Center(
            child: Image.network(data.url_graph),
          ),
        );
      },
    );
  }
}

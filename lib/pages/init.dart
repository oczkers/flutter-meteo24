import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';
import '../routes.gr.dart';
import 'menubar.dart';

// city graph
// TODO: RefreshIndicator - swipe to refresh
class InitPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(myProvider.cityname),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Router.navigator.pushNamed(Router.addcityPage);
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  myProvider.setCity(myProvider.cityname);
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
            child: Image.network(myProvider.url_graph),
          ),
        );
      },
    );
  }
}

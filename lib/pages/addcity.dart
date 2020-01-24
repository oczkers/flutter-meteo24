import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';
import '../routes.gr.dart';

// TODO: add map

class AddcityPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Dodaj miasto'), // localization instead of city? we can use cordinates probably
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                // onPressed: () {},
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: myProvider.cities_all.length,
            itemBuilder: (_, index) {
              var cityname = myProvider.cities_all.keys.toList()[index]; // this is ugly, should be parsed in model
              return ListTile(
                title: Text(cityname),
                // subtitle: Text(myProvider.cities_all[cityname]['province']),  // country, province, county
                onTap: () {
                  myProvider.addCity(cityname);
                  Router.navigator.pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}

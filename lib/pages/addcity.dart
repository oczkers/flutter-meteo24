import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../routes.gr.dart';

// TODO: add map

class AddcityPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            // title: Text('Dodaj miasto'), // localization instead of city? we can use cordinates probably
            title: TextField(
              decoration: InputDecoration(hintText: 'Wyszukaj...'),
              onChanged: (letters) {
                data.searchCity(letters);
              },
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: Icon(Icons.close),
            //     // onPressed: () {},
            //   ),
            // ],
          ),
          body: ListView.builder(
            itemCount: data.cities_found.length,
            itemBuilder: (_, index) {
              var cityname = data.cities_found[index]; // this is ugly, should be parsed in model
              return ListTile(
                title: Text(cityname),
                // subtitle: Text(myProvider.cities_all[cityname]['province']),  // country, province, county
                onTap: () {
                  data.addCity(cityname);
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

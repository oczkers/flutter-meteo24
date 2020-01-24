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
            itemCount: myProvider.citiesAll.length,
            itemBuilder: (_, index) {
              var cityname = myProvider.citiesAll[index];
              return ListTile(
                title: Text(cityname),
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

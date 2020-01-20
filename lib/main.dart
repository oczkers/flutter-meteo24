// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'myProvider.dart';
// import 'package:meteo24/myProvider.dart';

final String app_title = 'Meteo24';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      child: MaterialApp(
        // title: app_title,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
            appBar: AppBar(
              title: Text(myProvider.app_title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    myProvider.setCity(myProvider.cityname());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
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

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(builder: (context, myProvider, _) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: 10, // only top10 / myProvider.cities.length
                itemBuilder: (_, index) {
                  var cityname = myProvider.cities.keys.toList()[index];
                  return ListTile(
                    selected: myProvider.selected(cityname),
                    title: Text(cityname),
                    onTap: () {
                      myProvider.setCity(cityname);
                      Navigator.pop(context); // TODO?: move to provider
                    },
                  );
                },
              ),
            ),
            Divider(),
            // ListTile(
            //   title: Text('Komentarz'),
            //   onTap: () {}, // https://www.meteo.pl/komentarze/index1.php
            // ),
            ListTile(
              selected: myProvider.selected('legend'),
              title: Text('Legenda'),
              onTap: () {
                myProvider.displayLegend();
                Navigator.pop(context); // TODO?: move to provider
              },
            ),
          ],
        ),
        // child: Column(
        //   children: <Widget>[
        //     Padding(padding: EdgeInsets.only(top: 40)), // topbar
        //     // UserAccountsDrawerHeader(),
        //     Center(
        //       child: Text(
        //         'Cities',
        //         style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 18,
        //             // fontStyle: FontStyle.italic,
        //             color: Colors.blueGrey),
        //       ),
        //     ),
        //     Divider(),
        //     ListTile(
        //       title: Text('Warszawa'),
        //       onTap: () {
        //         myProvider.setParam('Warsaw');
        //         Navigator.pop(context); // TODO: move to provider
        //       },
        //     ),
        //     ListTile(
        //       title: Text('Kraków'),
        //       onTap: () {
        //         myProvider.setParam('Cracow');
        //         Navigator.pop(context);
        //       },
        //     ),
        //     Expanded(
        //       child: Align(
        //         alignment: FractionalOffset.bottomCenter,
        //         child: ListTile(
        //           title: Text('bottom menu'),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      );
    });
  }
}

// TODO: legend https://www.meteo.pl/um/metco/leg_um_en_cbase_256.png

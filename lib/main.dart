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
              title: Text(app_title),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    myProvider.setParam(
                        'https://raw.githubusercontent.com/nisrulz/flutter-examples/develop/image_from_network/img/loop_anim.gif');
                  },
                )
              ],
            ),
            drawer: MenuDrawer(),
            body: Center(
              child: Image.network(myProvider.getParam),
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
            Padding(padding: EdgeInsets.only(top: 40)), // topbar
            // UserAccountsDrawerHeader(),
            Center(
              child: Text(
                'Cities',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // fontStyle: FontStyle.italic,
                    color: Colors.blueGrey),
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Warszawa'),
              onTap: () {
                myProvider.setParam(
                    'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=406&col=250&lang=pl');
                Navigator.pop(context); // TODO: move to provider
              },
            ),
            ListTile(
              title: Text('Kraków'),
              onTap: () {
                myProvider.setParam(
                    'https://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate=2020011712&row=466&col=232&lang=pl');
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ListTile(
                  title: Text('bottom menu'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

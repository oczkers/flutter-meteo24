// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meteo24/routes.gr.dart';
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
        // home: HomePage(),
        initialRoute: Router.initPage,
        onGenerateRoute: Router.onGenerateRoute,
        navigatorKey: Router.navigatorKey,
      ),
    );
  }
}

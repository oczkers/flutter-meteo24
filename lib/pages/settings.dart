import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class SettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Ustawienia'),
          ),
          body: Text('cześć'),
        );
      },
    );
  }
}

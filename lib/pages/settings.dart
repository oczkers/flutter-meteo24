import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';

class SettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
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

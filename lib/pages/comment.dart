import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';

class CommentPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, myProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Meteo24 - Legenda'),
          ),
          body: Center(
            child: Text('comment'),
          ),
        );
      },
    );
  }
}

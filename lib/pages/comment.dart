import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';

class CommentPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Komentarz'),
          ),
          body: SingleChildScrollView(
            child: Html(
              data: data.comment,
              onLinkTap: (url) {
                launch(
                  url,
                  // forceWebView: true,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

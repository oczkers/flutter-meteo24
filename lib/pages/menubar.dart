import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../myProvider.dart';
import '../routes.gr.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(builder: (context, myProvider, _) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              // TODO?: customizable favourite items on top
              child: ListView.builder(
                itemCount: myProvider.cities.length,
                itemBuilder: (_, index) {
                  var cityname = myProvider.cities[index];
                  return Slidable(
                    actionPane: SlidableBehindActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Usuń',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          myProvider.removeCity(cityname);
                        },
                      )
                    ],
                    child: ListTile(
                      selected: myProvider.selected(cityname),
                      title: Text(cityname),
                      onTap: () {
                        myProvider.setCity(cityname);
                        Router.navigator.pop(); // TODO?: move to provider
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Komentarz'),
              onTap: () {
                Router.navigator.pop();
                Router.navigator.pushNamed(Router.commentPage);
              },
            ),
            ListTile(
              selected: myProvider.selected('legend'),
              title: Text('Legenda'),
              onTap: () {
                Router.navigator.pop();
                Router.navigator.pushNamed(Router.legendPage);
              },
            ),
          ],
        ),
      );
    });
  }
}

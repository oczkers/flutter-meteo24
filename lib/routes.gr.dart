// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:meteo24/pages/init.dart';
import 'package:meteo24/pages/legend.dart';
import 'package:meteo24/pages/comment.dart';

class Router {
  static const initPage = '/';
  static const legendPage = '/legend-page';
  static const commentPage = '/comment-page';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.initPage:
        return MaterialPageRoute(
          builder: (_) => InitPage(),
          settings: settings,
        );
      case Router.legendPage:
        return MaterialPageRoute(
          builder: (_) => LegendPage(),
          settings: settings,
        );
      case Router.commentPage:
        return MaterialPageRoute(
          builder: (_) => CommentPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

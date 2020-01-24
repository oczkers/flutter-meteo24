import 'package:auto_route/auto_route_annotations.dart';
import 'pages/init.dart';
import 'pages/legend.dart';
import 'pages/comment.dart';
import 'pages/settings.dart';

@autoRouter
class $Router {
  @initial
  InitPage initPage;
  LegendPage legendPage;
  CommentPage commentPage;
  SettingsPage settingsPage;
}

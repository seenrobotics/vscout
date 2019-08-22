import 'dart:io';
import 'package:path/path.dart';
import 'package:vscout_cli/src/view/view.dart';
import 'dart:async';

abstract class UserQuery {
  String queryTitle;
  String queryContent;
  Future proccessResponse(List<String> args);
}
import 'dart:io';
import 'package:path/path.dart';
import 'package:vscout_cli/src/views/view.dart';
import 'dart:async';

abstract class UserQuery {
  String queryTitle;
  String queryContent;
  Future proccessResponse(List<String> args);
}

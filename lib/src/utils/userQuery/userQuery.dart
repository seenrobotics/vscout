import 'dart:async';

abstract class UserQuery {
  String queryTitle;
  String queryContent;
  Future proccessResponse(List<String> args);
}

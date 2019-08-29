import 'dart:async';
import 'dart:io';
import 'package:tuple/tuple.dart';

import 'package:vscout/transfer.dart' show Response;

class Request<T> {
  String method;
  int status = HttpStatus.noContent;
  Function onDone;
  Response response;
  var queryParameters;
  var queryData;
  Map realParameters;
  Map realData;
  List args = List();
  List<Tuple2> optionArgs = List();
  Map flags = Map();
  Map options = Map();

  Request(String method) {
    this.method = method;
  }

  recieveResponse(Future<Response> response) async {
    this.status = HttpStatus.processing;
    this.response = await response;
    await response.then((value) {
      this.status = value.status;
      this.onDone(value);
    });
  }

  setCallback(Function callBack) {
    this.onDone = callBack;
  }
}

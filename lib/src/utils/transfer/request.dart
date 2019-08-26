import 'dart:async';
import 'dart:io';

import 'package:vscout/transfer.dart' show Response;

class Request<T> {
  String method;
  int status = HttpStatus.noContent;
  Function onDone;
  Response response;
  var queryParameters;
  var queryData;
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

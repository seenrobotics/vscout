import 'dart:io';

class Response<T> {
  int status = HttpStatus.noContent;
  List data = List();
  var query;
  List origin = List();

  bool statusCheck([var query = false, var origin]) {
    // TODO: Make a proper status check system
    if (this.status != HttpStatus.ok) {
      this.origin.add([origin, query]);
      return false;
    }
    return true;
  }

  addData(var data, var origin, {bool join = false, bool failed = false}) {
    if (data is List && join == true) {
      this.data += data;
    } else {
      this.data.add(data);
    }
    this.origin.add(origin);
    this.status = failed ? HttpStatus.badRequest : HttpStatus.ok;
    return;
  }

  joinResponse(Response response) {
    this.data += response.data;
    this.status = response.status;
    this.origin += response.origin;
  }

  Map<String, dynamic> readResponse() {
    Map<String, dynamic> responseMap = Map();
    responseMap['status'] = this.status;
    responseMap['data'] = this.data;
    responseMap['query'] = this.query;
    responseMap['origin'] = this.origin;
    return responseMap;
  }
}

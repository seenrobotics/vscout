import 'dart:io';

class Response<T> {
  int status = HttpStatus.noContent;
  List<Map> data = List();
  var query;
  List origin = List();

  List<String> get keys {
    List<String> keys = List();
    for (Map record in this.data) {
      keys.add(record['key']);
    }
    return keys;
  }

  bool statusCheck([var query = false, var origin]) {
    // TODO: Make a proper status check system
    if (this.status != HttpStatus.ok) {
      this.origin.add([origin, query]);
      return false;
    }
    return true;
  }

  addRecords(List<Map> data, var origin, {bool failed = false}) {
    this.data += data;
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
    responseMap['data'] = this.keys;
    responseMap['data'] = this.data;
    responseMap['query'] = this.query;
    responseMap['origin'] = this.origin;
    return responseMap;
  }
}

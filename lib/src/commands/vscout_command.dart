import '../response/response.dart';
import 'package:vscout_cli/src/models/model.dart';
import 'dart:async';
import 'package:vscout_cli/src/request/request.dart';

mixin VscoutCommand {
  Model viewModel;
  var results;
  bool verbose;
  StreamSubscription streamSubscription;
  Request request;
  String get name;
  bool printResponse(verbose, {bool keysOnly = true}) {
    if (verbose == true) {
      print('${this.results.readResponse(keysOnly)}\n');
    } else if (keysOnly) {
      for (var key in this.results.keys) {
        print("$key\r");
      }
      print("${this.results.keys} \n \n");
    } else {
      for (Map data in this.results.data) {
        print("$data\r");
      }
    }
    print("\n");
    return true;
  }

  newRequest() {
    this.request = Request(this.name);
  }

  void handleResponse(data);

  initializeStream() {
    this.streamSubscription = this
        .viewModel
        .outputController
        .stream
        .listen((data) => this.handleResponse(data));
    this.streamSubscription.pause();
  }
}

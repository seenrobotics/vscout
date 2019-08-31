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
  bool printResponse(verbose) {
    if (verbose == true) {
      print('${this.results.readResponse()} \n \n');
    } else {
      print("${this.results.data} \n \n");
    }
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

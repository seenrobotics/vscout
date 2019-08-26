import 'dart:async';

import 'package:vscout/transfer.dart';

import 'package:vscout/view_models.dart' show ViewModel;

mixin VscoutCommand {
  ViewModel viewModel;
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

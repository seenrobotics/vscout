import 'dart:async';

import 'package:vscout/transfer.dart';
import 'package:args/command_runner.dart';
import 'package:tuple/tuple.dart';
import 'package:vscout/view_models.dart' show ViewModel;

mixin VscoutCommand on Command {
  ViewModel viewModel;
  var results;
  bool verbose;
  StreamSubscription streamSubscription;
  Request request;
  String get name;
  bool printResponse(verbose,
      {bool keysOnly = true, bool responseData = false}) {
    if (verbose == true) {
      print('${this.results.readResponse(keysOnly)}\n');
    } else if (responseData == true) {
      for (var data1 in this.results.data) {
        print("$data1\r");
      }
    } else if (!keysOnly) {
      for (Map data in this.results.data) {
        print("$data\r");
      }
    } else {
      for (var key in this.results.keys) {
        print("$key\r");
      }
    }
    print("\n");
    return true;
  }

  void parseArguments() {
    this.newRequest();
    List args = List();
    List<Tuple2> optionArgs = List();
    for (String yeet in argResults.arguments) {
      var results = argParser.parse([yeet]);
      bool parsedOption = false;
      for (String option in results.options) {
        if (results.wasParsed(option)) {
          optionArgs.add(Tuple2(option, results[option]));
          args.add(results[option]);
          parsedOption = true;
          break;
        }
      }
      if (!parsedOption) {
        optionArgs.add(Tuple2(Null, results.rest[0]));
        args.add(results.rest[0]);
      }
    }
    this.request.args = args;
    this.request.optionArgs = optionArgs;
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

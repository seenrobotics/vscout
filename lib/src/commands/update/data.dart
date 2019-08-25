import 'package:args/command_runner.dart';

import '../../models/update/data.dart';
import '../vscout_command.dart';
import 'dart:async';

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';
  var results;

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
    this.viewModel = UpdateDataModel();
    this.initializeStream();
  }
  @override
  void handleResponse(data) {
    print('Updated entries: \n');
    this.results = data;
    this.printResponse(argResults['verbose']);
    this.streamSubscription.pause();
  }

  @override
  run() async {
    this.streamSubscription.resume();
    Map data = {
      "queryParameters": argResults.rest[0],
      "queryData": argResults.rest[1]
    };
    viewModel.inputController.add(data);
  }
}

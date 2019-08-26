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
    this.newRequest();
    this.request.queryData = argResults.rest[0];
    this.request.queryParameters = argResults.rest[1];
    this.streamSubscription.resume();
    viewModel.inputController.add(this.request);
  }
}

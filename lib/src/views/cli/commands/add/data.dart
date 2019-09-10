import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show AddDataVM;

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Add data to the database';

  DataCommand() {
    argParser
      ..addFlag('verbose', defaultsTo: false)
      ..addMultiOption('data', abbr: 'd', splitCommas: true)
      ..addMultiOption('json', splitCommas: false);
    this.viewModel = AddDataVM();
    this.initializeStream();
  }

  @override
  void handleResponse(data) {
    print('Added entries: \n \n');
    this.results = data;
    this.printResponse(argResults['verbose']);
    this.streamSubscription.pause();
  }

  @override
  run() async {
    this.parseArguments();
    this.streamSubscription.resume();
    viewModel.inputController.add(this.request);
  }
}

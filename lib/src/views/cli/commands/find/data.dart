import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show FindDataVM;

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';

  DataCommand() {
    argParser
      ..addFlag('verbose', defaultsTo: false)
      ..addFlag('new', defaultsTo: false)
      ..addMultiOption('create', abbr: 'c', splitCommas: true)
      ..addMultiOption('ref', abbr: 'r', splitCommas: false);

    this.viewModel = FindDataVM();
    this.initializeStream();
  }
  @override
  void handleResponse(data) {
    print('Found entries:\n');
    this.results = data;
    this.printResponse(argResults['verbose']);
    this.streamSubscription.pause();
  }

  @override
  run() async {
    this.parseArguments();
    this.request.flags['new'] = argResults['new'];
    this.streamSubscription.resume();
    viewModel.inputController.add(this.request);
  }
}

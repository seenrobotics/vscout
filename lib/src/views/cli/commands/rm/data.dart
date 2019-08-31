import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show RmDataVM;

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'remove data from the database';

  DataCommand() {
    argParser
      ..addFlag('verbose', defaultsTo: false)
      ..addMultiOption('ref', abbr: 'r', splitCommas: false)
      ..addMultiOption('key', abbr: 'k', splitCommas: true);
    this.viewModel = RmDataVM();
    this.initializeStream();
  }
  @override
  void handleResponse(data) {
    print('Removed entries: \n \n');
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

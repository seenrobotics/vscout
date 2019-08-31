import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show FilterVM;

class FilterCommand extends Command with VscoutCommand {
  @override
  String get name => 'filter';
  @override
  String get description => 'Create or modify a filter';

  FilterCommand() {
    argParser
      ..addFlag('verbose', defaultsTo: false)
      ..addFlag('save', defaultsTo: false, abbr: 's')
      ..addFlag('new', defaultsTo: false, abbr: 'n')
      ..addMultiOption('create', abbr: 'c', splitCommas: true)
      ..addMultiOption('ref', abbr: 'r', splitCommas: false);

    this.viewModel = FilterVM();
    this.initializeStream();
  }
  @override
  void handleResponse(data) {
    print('Filter:\n');
    this.results = data;
    this.printResponse(argResults['verbose'], responseData: true);
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

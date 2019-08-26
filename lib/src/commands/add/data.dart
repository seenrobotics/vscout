import 'package:args/command_runner.dart';
import 'package:vscout_cli/src/commands/vscout_command.dart';

import '../../models/add/data.dart';

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Add data to the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
    this.viewModel = AddDataModel();
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
    this.streamSubscription.resume();
    Map data = {"queryParameters": argResults.rest[0]};
    viewModel.inputController.add(data);
  }
}

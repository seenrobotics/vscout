import 'package:args/command_runner.dart';

import '../../models/rm/data.dart';
import '../vscout_command.dart';

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'remove data from the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
    this.viewModel = RemoveDataModel();
    this.initializeStream();
  }
  @override
  void handleResponse(data) {
    print('Found entries: \n \n');
    this.results = data;
    this.printResponse(argResults['verbose']);
    this.streamSubscription.pause();
  }

  @override
  run() async {
    this.newRequest();
    this.request.queryParameters = argResults.rest[0];
    this.streamSubscription.resume();
    viewModel.inputController.add(this.request);
  }
}

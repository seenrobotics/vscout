import 'package:args/command_runner.dart';

import '../../models/update/data.dart';
import '../vscout_command.dart';

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';
  var results;

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final UpdateDataModel findDataModel = UpdateDataModel();
    this.results = await findDataModel.updateStringData(
        argResults.rest[0], argResults.rest[1]);
    print('Found entries: \n');
    return this.printResponse(argResults['verbose']);
  }
}

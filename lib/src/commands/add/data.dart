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
  }

  @override
  run() async {
    final AddDataModel addDataModel = AddDataModel();
    this.results = await addDataModel.addStringData(argResults.rest[0]);
    print('Added new entry \n \n');
    return this.printResponse(argResults['verbose']);
  }
}

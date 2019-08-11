import 'package:args/command_runner.dart';

import '../../models/find/data.dart';
import '../vscout_command.dart';

class DataCommand extends Command with VscoutCommand {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }
  @override
  run() async {
    final FindDataModel findDataModel = FindDataModel();
    this.results = await findDataModel.findStringData(argResults.rest[0]);
    print('Found entries: \n \n');
    return this.printResponse(argResults['verbose']);
  }
}

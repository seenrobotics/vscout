import 'package:args/command_runner.dart';

import '../../models/find/data.dart';
import '../vscout_command.dart';

class FileCommand extends Command with VscoutCommand {
  @override
  String get name => 'file';
  @override
  String get description => 'Find entries in the database through JSON File';

  FileCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final FindDataModel addDataModel = new FindDataModel();
    this.results = await addDataModel.findFileData(argResults.rest[0]);
    print('Entries found \n \n');
    return this.printResponse(argResults['verbose']);
  }
}

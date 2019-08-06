import 'package:args/command_runner.dart';

import '../../models/add/data.dart';

class FileCommand extends Command {
  @override
  String get name => 'file';
  @override
  String get description => 'Add entry to the database through JSON File';
  Map results;

  FileCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final AddDataModel addDataModel = new AddDataModel();
    this.results = await addDataModel.addFileData(argResults.rest[0]);
    print('Added new entry \n \n');
    if (argResults['verbose'] == true) {
      print('${this.results.toString()} \n \n');
    } else {
      print("${this.results['data'].toString()} \n \n");
    }
    return;
  }
}

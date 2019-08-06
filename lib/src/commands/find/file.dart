import 'package:args/command_runner.dart';

import '../../models/find/data.dart';

class FileCommand extends Command {
  @override
  String get name => 'file';
  @override
  String get description => 'Find entries in the database through JSON File';
  Map results;

  FileCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final FindDataModel addDataModel = new FindDataModel();
    this.results = await addDataModel.findFileData(argResults.rest[0]);
    print('Entries found \n \n');
    if (argResults['verbose'] == true) {
      print('${this.results.toString()} \n \n');
    } else {
      print("${this.results['data'].toString()}+ \n \n");
    }
    return;
  }
}

import 'package:args/command_runner.dart';

import '../../models/update/data.dart';

class DataCommand extends Command {
  @override
  String get name => 'data';
  @override
  String get description => 'Find data to the database';
  var databaseHandler;
  Map results;

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    final UpdateDataModel findDataModel = new UpdateDataModel();
    this.results = await findDataModel.updateStringData(
        argResults.rest[0], argResults.rest[1]);
    print('Found entries: \n \n');
    if (argResults['verbose'] == true) {
      print('${this.results.toString()} \n \n');
    } else {
      print("${this.results['data'].toString()} \n \n");
    }
    return;
  }
}

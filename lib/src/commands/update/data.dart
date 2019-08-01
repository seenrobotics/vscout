import 'package:args/command_runner.dart';
import '../../utils/utils.dart';
class DataCommand extends Command {
  @override
  String get name => 'data';
  @override
  String get description => 'Update data to the database';
  var databaseHandler;

  DataCommand(databaseHandler) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = databaseHandler;
  }

  @override
  run() async {
    Map properties = parseArgsJson(argResults.rest[0]);
    print(properties);
    var result = await this.databaseHandler.addEntry(properties);
    if (argResults['verbose'] == true) {
      print(result);
    }
  }
}

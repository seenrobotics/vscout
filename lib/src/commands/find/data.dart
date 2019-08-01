import 'package:args/command_runner.dart';
import '../../utils/utils.dart';

class DataCommand extends Command {
  @override
  String get name => 'data';

  @override
  String get description => 'Find data from database';

  var databaseHandler;

  DataCommand(databaseHandler) {
    argParser..addFlag('verbose', defaultsTo: false);
    this.databaseHandler = databaseHandler;
  }

  @override
  run() async {
    Map filters = parseArgsJson(argResults.rest[0]);
    var results = await this.databaseHandler.getMatches(filters);
    print(filters);
    print(results);
  }
}

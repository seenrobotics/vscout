import 'package:args/command_runner.dart';
import 'find/data.dart';

class FindCommand extends Command {
  @override
  String get name => 'find';

  @override
  String get description => 'Find data in database';

  FindCommand(databaseHandler) {
    addSubcommand(DataCommand(databaseHandler));
  }
  @override
  run() async {
    // var dataType = argResults.wasParsed('data-type');
    // print(dataType);
  }
}

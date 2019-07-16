import 'package:args/command_runner.dart';

class DataTypeCommand extends Command {
  @override
  String get name => 'data-type';

  @override
  String get description => 'Add data types to the database';

  DataTypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }
  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Added data type ${argResults.rest[0]}');
    }
  }
}

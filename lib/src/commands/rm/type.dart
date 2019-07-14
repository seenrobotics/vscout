import 'package:args/command_runner.dart';

class TypeCommand extends Command {
  @override
  String get name => 'data-type';

  @override
  String get description => 'Remove data types from the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Removed data type ${argResults.rest[0]}');
    }
  }
}

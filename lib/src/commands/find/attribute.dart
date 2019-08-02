import 'package:args/command_runner.dart';

class AttributeCommand extends Command {
  @override
  String get name => 'attribute';

  @override
  String get description => 'Find attribute in the database';

  DataTypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Found attribute ${argResults.rest[0]}');
    }
  }
}

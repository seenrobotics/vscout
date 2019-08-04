import 'package:args/command_runner.dart';

class AttributeCommand extends Command {
  @override
  String get name => 'attribute';

  @override
  String get description => 'Add attribute to the database';

  TypeCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print('Added attribute ${argResults.rest[0]}');
    }
  }
}

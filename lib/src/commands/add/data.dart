import 'package:args/command_runner.dart';

class DataCommand extends Command {
  @override
  String get name => 'data';

  @override
  String get description => 'Add data to the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    // TODO: Replace with actual command.
    if (argResults['verbose'] == true) {
      print(
          'Added data ${argResults.arguments[1]} with type ${argResults.arguments[0]}');
    }
  }
}

import 'package:args/command_runner.dart';

import 'find/attribute.dart';
import 'find/data.dart';
import 'find/file.dart';

class FindCommand extends Command {
  @override
  String get name => 'find';

  @override
  String get description => 'Find data in database';

  FindCommand() {
    addSubcommand(AttributeCommand());
    addSubcommand(DataCommand());
    addSubcommand(FileCommand());
  }
  @override
  run() async {
    ///TODO: Add functionality
  }
}

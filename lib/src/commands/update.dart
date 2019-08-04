import 'package:args/command_runner.dart';

import 'update/data.dart';
import 'update/attribute.dart';

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'Update data or attributes from the database';

  UpdateCommand(databaseHandler) {
    addSubcommand(DataCommand(databaseHandler));
    addSubcommand(AttributeCommand());
  }
  @override
  run() async {}
}

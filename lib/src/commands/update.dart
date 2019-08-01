import 'package:args/command_runner.dart';

import 'update/data.dart';
import 'update/type.dart';

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'Update data or data types to the database';

  UpdateCommand(databaseHandler) {
    addSubcommand(DataCommand(databaseHandler));
    addSubcommand(TypeCommand());
    
  }
  @override
  run() async {}
}

import 'package:args/command_runner.dart';
import 'add/team_entry.dart';
import 'add/data.dart';
import 'add/type.dart';

class AddCommand extends Command {
  @override
  String get name => 'add';

  @override
  String get description => 'Add data or data types to the database';

  AddCommand(database) {
    addSubcommand(DataCommand());
    addSubcommand(TypeCommand());
    addSubcommand(TeamEntryCommand(database));
    
  }
  @override
  run() async {}
}

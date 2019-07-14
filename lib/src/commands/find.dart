import 'package:args/command_runner.dart';

class FindCommand extends Command {
  @override
  String get name => 'find';

  @override
  String get description => 'Find data in database';

  FindCommand();
  @override
  run() async {}
}

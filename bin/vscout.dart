library vscout_cli.tool;

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:vscout_cli/vscout_cli.dart';

// The exit code for a general error.
int generalError = 1;

main(List<String> args) async {
  List<dynamic> commands = List();
  // Create a new database handler with empty constructor.
  DatabaseHandler databaseHandler = DatabaseHandler();
  // Run all constructor functions in async function to await database construction completion.
  //  This is to prevent calls to an unfinished database object.
  // Add database related commands only if database exists, else only add [init] and [config].
  if (await databaseHandler.initializeDatabase()) {
    commands.add(AddCommand());
    commands.add(FindCommand());
    commands.add(LsCommand());
    commands.add(RmCommand());
    commands.add(ShowCommand());
    commands.add(UpdateCommand());
  }
  commands.add(InitCommand());
  commands.add(ConfigCommand());
  var runner = CommandRunner(
      'vscout',
      'Robotics scouting software'
          '\n\n'
          'https://vscout.readthedocs.io');

  runner.argParser.addFlag('verbose', negatable: false);
  commands.forEach((command) => runner..addCommand(command));

  return await runner.run(args).catchError((exception, stackTrace) {
    if (exception is String) {
      // STDOUT is buffered and writes are in batches.
      stdout.writeln(exception);
    } else {
      // STDERR is unbuffered and every character is written as soon as it is available.
      stderr.writeln('Error Message: $exception');
      if (args.contains('--verbose')) {
        stderr.writeln(stackTrace);
      }
    }
    exitCode = generalError;
  }).whenComplete(() {
    // ANSI escape code to reset (all attributes off).
    stdout.write(resetAll.wrap(''));
  });
}

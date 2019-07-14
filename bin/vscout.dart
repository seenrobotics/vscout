library vscout_cli.tool;

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import 'package:vscout_cli/vscout_cli.dart';

// The exit code for a general error.
int generalError = 1;

main(List<String> args) async {
  var runner = CommandRunner(
      'vscout',
      'Robotics scouting software'
          '\n\n'
          'https://vscout.readthedocs.io');

  runner.argParser.addFlag('verbose', negatable: false);

  runner..addCommand(AddCommand());
  runner..addCommand(ConfigCommand());
  runner..addCommand(FindCommand());
  runner..addCommand(InitCommand());
  runner..addCommand(LsCommand());
  runner..addCommand(RmCommand());
  runner..addCommand(ShowCommand());

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

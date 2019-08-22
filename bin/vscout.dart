library vscout_cli.tool;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';

import 'package:vscout_cli/src/view/view.dart';
import 'package:vscout_cli/vscout_cli.dart';

// The exit code for a general error.

main(List<String> args) async {
  print(
      """                                                                                         
                  .,,,,,,.                       ,,,,,,,  .,,,,,,,,,,,,,,,,,,,,,,,.                
                   %@@@@@@%                    ,@@@@@@@* #@@@@@@@@@@@@@@@@@@@@@@@%                 
                    %@@@@@@%                  (@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@/                  
                     /@@@@@@@                /@@@@@@@.,@@@@@@@@@@@@@@@@@@@@@@@@/                   
                      /@@@@@@@              /@@@@@@&..@@@@@@@*        /@@@@@@@(                    
                       .@@@@@@@,           %@@@@@@& .@@@@@@@/        *@@@@@@@.                     
                         @@@@@@@/        ,@@@@@@@* %@@@@@@@         (@@@@@@%                       
                          %@@@@@@*      .@@@@@@@* #@@@@@@@         &@@@@@@&                        
                           %@@@@@@%    .@@@@@@@/ %@@@@@@@.        &@@@@@@&                         
                            /@@@@@@#  /@@@@@@@.   /@@@@@@@.      %@@@@@@(                          
                             ,@@@@@@@%@@@@@@@      ,@@@@@@@,      %@@@@*                           
                              ,@@@@@@@@@@@@% /.      @@@@@@@#      %@@                             
                                @@@@@@@@@@% *@@/      @@@@@@@(      *.                             
                                 @@@@@@@@/ %@@@@*     .&@@@@@@(                                    
                                  (@@@@@,.&@@@@@@*      #@@@@@@@                                   
                                   #@@@,.@@@@@@@/        *@@@@@@@,                                 
                                    ,@ .@@@@@@@/        ,@@@@@@@*                                  
                                      *@@@@@@@.        ,@@@@@@@*                                   
                                      .&@@@@@@*       %@@@@@@@                                     
                                        &@@@@@@%     %@@@@@@@                                      
                                         @@@@@@@%   #@@@@@@#                                       
                                          #@@@@@@# @@@@@@@%                                        
                                           /@@@@@@@@@@@@@(                                         
                                            .@@@@@@@@@@@.                                          
                                             .@@@@@@@@@,                                           
                                              .&@@@@@@                                             
                                                %@@@&                                              
                                                 %@/                                               
                                                  .                                                                                                                                                                                          
  """);

  print('Welcome to vscout cli\n'
      'Robotics scouting software\n'
      'For more information, visit\nhttps://vscout.readthedocs.io');

  List<dynamic> runCommands = List();
  // Create a new database handler with empty constructor.
  DatabaseHandler databaseHandler = DatabaseHandler();
  // Run all constructor functions in async function to await database construction completion.
  //  This is to prevent calls to an unfinished database object.
  // Add database related commands only if database exists, else only add [init] and [config].

  await databaseHandler.initializeDatabase();

  var runner = CommandRunner(
      'vscout',
      'Robotics scouting software'
          '\n\n'
          'https://vscout.readthedocs.io');

  runner.argParser.addFlag('verbose', negatable: false);
  runner..addCommand(VscoutExecCommand());
  runner..addCommand(VscoutCommand());
  CliView view = CliView();
  view.runner = runner;


  // Stream cmdLine = Utf8Decoder().bind(stdin).transform(InputArgsParser());
  // await view.listenTo(cmdLine);

  await view.listenTo(stdin);

  await view.inputSubscription.asFuture();
  print('vscout exited with code 0');
}

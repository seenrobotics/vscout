import '../response/response.dart';
import 'package:vscout_cli/src/models/model.dart';
import 'dart:async';
mixin VscoutCommand {
  Model viewModel;
  var results;
  bool verbose;
  StreamSubscription streamSubscription;

  bool printResponse(verbose) {
    if (verbose == true) {
      print('${this.results.readResponse()} \n \n');
    } else {
      print("${this.results.data} \n \n");
    }
    return true;
  }
  void handleResponse(data);

  initializeStream(){
    this.streamSubscription = this.viewModel.outputController.stream.listen((data) => this.handleResponse(data));
    this.streamSubscription.pause();
  }
  
}

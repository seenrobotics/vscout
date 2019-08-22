import '../response/response.dart';

mixin VscoutCommand {
  var results;
  bool verbose;
  bool printResponse(verbose) {
    if (verbose == true) {
      print('${this.results.readResponse()} \n \n');
    } else {
      print("${this.results.data} \n \n");
    }
    return true;
  }
}

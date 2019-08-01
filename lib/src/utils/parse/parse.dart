import 'dart:convert';

  /// Formats CLI arguments to make them JSON parsable.
  //  Turns [{'asdf':'asdf'}] -> [{"asdf":"asdf"}].
parseArgsJson(String str) {
//  Replace all single quotes ' with double quotes " so [json.decode] is able to read it. 
    String quoteReplace = str.replaceAll("\'", ('\"'));
//  Json decode string to map.
    Map baseMap = json.decode(quoteReplace);
// Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
    Map result = Map<String, String>();
    baseMap.forEach((k, v) => result[k is String? k.trim() : k.toString().trim()] = v is String ? v.trim() : v.toString().trim());
    return result;
    
  }
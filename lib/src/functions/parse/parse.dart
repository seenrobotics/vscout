import 'dart:convert';

  /// Makes cmd arguments JSON parsable
  //  Turns [{'asdf':'asdf'}] -> [{"asdf":"asdf"}]
parseArgsJson(String str) {
//  Replace all single quotes ' with double quotes " so json.decode is able to read it. 
    String quoteReplace = str.replaceAll("\'", ('\"'));
//  Json decode
    Map baseMap = json.decode(quoteReplace);
// Kill trailing white space, convert inputs to string to allow for staticly typed DART methods
// This makes life alot easier
    Map result = Map<String, String>();
    baseMap.forEach((k, v) => result[k is String? k.trim() : k.toString().trim()] = v is String ? v.trim() : v.toString().trim());
    return result;
    
  }
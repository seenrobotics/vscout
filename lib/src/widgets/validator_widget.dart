String validate_string_length_name(dynamic value) {
  String property = "Name";
  int minLength = 3;
  if (value.length < minLength) {
    return '$property must be greater than ${minLength - 1} characters.';
  } else {
    return null;
  }
}

String validate_string_length_team(dynamic value) {
  String property = "Team";
  int minLength = 3;
  if (value.length < minLength) {
    return '$property must be greater than ${minLength - 1} characters.';
  } else {
    return null;
  }
}

String validate_phone_number(String value) {
  // ITU-T E.123 compliant RegEx.
  Pattern pattern = r'^\+(?:[0-9]●?){6,14}[0-9]$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter Valid Email';
  } else {
    return null;
  }
}

String validate_email(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Enter Valid Email';
  } else {
    return null;
  }
}

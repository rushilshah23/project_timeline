String emailValidator(String content) {
  if (content.contains('@')) {
    if (content.length == 0) {
      return 'Please enter your Email ID';
    } else {
      return null;
    }
  } else {
    return 'Please enter a VALID Email ID';
  }
}

String passwordValidator(String content) {
  if (content.length < 8) {
    return 'Minimum 8 DIGIT password';
  } else {
    return null;
  }
}

String renameValidator(String content) {
  if (content.length != 0) {
    if (content.contains("#") ||
        content.contains("[") ||
        content.contains("]") ||
        content.contains("*") ||
        content.contains("/") ||
        content.contains("?")) {
      return "enter valid folder name";
      // "Folder name should not contains invalid characters like #,[,],*,?";
    } else
      return null;
  } else
    return "Enter new filename";
}

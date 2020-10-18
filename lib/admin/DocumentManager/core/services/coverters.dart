List<String> getEmailList(String emailListString) {
  List<String> emailList;
  emailListString = emailListString.replaceAll(" ", "");
  emailList = emailListString.split(',');
  emailList.forEach((element) {
    print(element);
  });
  return emailList;
}

import 'dart:convert';

String accountList = '{"accountList": [{"id": "test","password":"1234"}]}';

class Account {
  late final dynamic account;

  void getAccountList() {
    account = jsonDecode(accountList);
    print(account);
    print(account["accountList"][0]);
    for (var x in account["accountList"]) {
      print(x["id"]);
      print(x["password"]);
    }
  }
}

void main() {
  Account a = Account();
  a.getAccountList();
}
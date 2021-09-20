import 'package:flutter/material.dart';
import 'package:wall/model/biz/account/account.dart';

class AccountLocalProvider extends ChangeNotifier {
  // 这个账户仅模型有id, 签名，昵称，头像
  Account? _account;

  // 冗余accountId
  String? _accountId;

  Account? get account => _account;

  String? get accountId => _accountId;

  void refresh() {
    notifyListeners();
  }

  void setAccount(Account? account) {
    _account = account;
    _accountId = account == null ? "" : account.id ?? "";
    refresh();
  }
}

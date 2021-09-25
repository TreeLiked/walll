import 'package:wall/model/biz/account/account.dart';
import 'package:wall/model/biz/tweet/tweet_account.dart';
import 'package:wall/util/str_util.dart';

class Gender {
  final String name;
  final String zhTag;

  const Gender({required this.name, required this.zhTag});

  static const male = Gender(name: 'MALE', zhTag: '男');
  static const female = Gender(name: 'FEMALE', zhTag: '女');
  static const unknown = Gender(name: 'UNKNOWN', zhTag: '未知');

  static Gender parseGender(String str) {
    if (StrUtil.isEmpty(str)) {
      return Gender.unknown;
    }
    str = str.toUpperCase();
    if (str == male.name) {
      return male;
    }
    if (str == female.name) {
      return female;
    }
    return Gender.unknown;
  }

  static Gender parseGenderByAccount(Account? account) {
    if (account == null) {
      return Gender.unknown;
    }
    return parseGender(account.gender!);
  }

  static Gender parseGenderByTweetAccount(TweetAccount? account) {
    if (account == null) {
      return Gender.unknown;
    }
    return parseGender(account.gender!);
  }
}

var genderMap = {
  'MALE': Gender.male,
  'FEMALE': Gender.female,
  'UNKNOWN': Gender.unknown,
};

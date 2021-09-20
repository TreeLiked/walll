class RegTemp {
  static String? avatarUrl;
  static String? nick;
  static String? phone;
  static String? invitationCode;
  static int? orgId;

  RegTemp._();


  void reset() {
    avatarUrl = null;
    nick = null;
    phone = null;
    invitationCode = null;
    orgId = null;
  }
}

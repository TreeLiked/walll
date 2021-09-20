class ResultCode {
  /// 参数不合法
  static const String invalidParam = "519";

  /// 不合法的手机号 不满足手机号格式
  static const String invalidPhone = "520";

  /// 手机号未被注册，不允许登录
  static const String unRegisteredPhone = "521";

  /// 手机号已被注册，无法再被注册
  static const String registeredPhone = "522";

  /// 登录失败
  static const String loginError = "523";

  /// 无效的邀请码
  static const String invalidInvitationCode = "524";

  /// 注册失败
  static const String registerError = "525";

  // 昵称存在
  static const String nickExisted = "526";

  /// 登出
  static const String loginOut = "1000";
}
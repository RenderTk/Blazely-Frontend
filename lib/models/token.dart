class Token {
  Token({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
    );
  }
}

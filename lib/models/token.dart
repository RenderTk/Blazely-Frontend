import 'package:jwt_decoder/jwt_decoder.dart';

class Token {
  Token({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;
  bool get isExpired => JwtDecoder.isExpired(accessToken!);

  DateTime get accessTokenExpiration =>
      JwtDecoder.getExpirationDate(accessToken!);
  DateTime get refreshTokenExpiration =>
      JwtDecoder.getExpirationDate(refreshToken!);

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
    );
  }
}

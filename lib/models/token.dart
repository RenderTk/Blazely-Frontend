import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'token.g.dart';

@JsonSerializable()
@CopyWith()
class Token {
  @JsonKey(name: 'access')
  final String? accessToken;

  @JsonKey(name: 'refresh')
  final String? refreshToken;

  Token({this.accessToken, this.refreshToken});

  bool get isExpired => JwtDecoder.isExpired(accessToken!);

  DateTime get accessTokenExpiration =>
      JwtDecoder.getExpirationDate(accessToken!);

  DateTime get refreshTokenExpiration =>
      JwtDecoder.getExpirationDate(refreshToken!);

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

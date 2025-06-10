// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TokenCWProxy {
  Token accessToken(String? accessToken);

  Token refreshToken(String? refreshToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Token(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Token(...).copyWith(id: 12, name: "My name")
  /// ````
  Token call({String? accessToken, String? refreshToken});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfToken.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfToken.copyWith.fieldName(...)`
class _$TokenCWProxyImpl implements _$TokenCWProxy {
  const _$TokenCWProxyImpl(this._value);

  final Token _value;

  @override
  Token accessToken(String? accessToken) => this(accessToken: accessToken);

  @override
  Token refreshToken(String? refreshToken) => this(refreshToken: refreshToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Token(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Token(...).copyWith(id: 12, name: "My name")
  /// ````
  Token call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
  }) {
    return Token(
      accessToken:
          accessToken == const $CopyWithPlaceholder()
              ? _value.accessToken
              // ignore: cast_nullable_to_non_nullable
              : accessToken as String?,
      refreshToken:
          refreshToken == const $CopyWithPlaceholder()
              ? _value.refreshToken
              // ignore: cast_nullable_to_non_nullable
              : refreshToken as String?,
    );
  }
}

extension $TokenCopyWith on Token {
  /// Returns a callable class that can be used as follows: `instanceOfToken.copyWith(...)` or like so:`instanceOfToken.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TokenCWProxy get copyWith => _$TokenCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  accessToken: json['access'] as String?,
  refreshToken: json['refresh'] as String?,
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'access': instance.accessToken,
  'refresh': instance.refreshToken,
};

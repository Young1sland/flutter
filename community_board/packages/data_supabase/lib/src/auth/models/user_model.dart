import 'package:domain/auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_model.g.dart';

@JsonSerializable(createToJson: false)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.avatarUrl,
    required super.role,
  });

  //factory 생성자: 객체를 생성하는 특별한 생성자. 객체 생성 과정을 커스텀 가능
  factory UserModel.fromSUpabaseUser(User user) {
    final metaData = user.userMetadata ?? {};

    return UserModel(
      id: user.id,
      username: metaData['username'] as String? ?? '',
      avatarUrl: metaData['avatarUrl'] as String? ?? '',
      role: metaData['role'] as String? ?? 'user',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'avatar_url')
  @override
  String? get avatarUrl;
}

/**
*
Supabase Auth를 쓰면 내부적으로 auth.users 테이블 자동으로 존재.
저장되는 것
- id
- email
- phone
- user_metadata
- app_metadata
- created_at
*
**/

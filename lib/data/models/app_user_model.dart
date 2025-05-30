// lib/data/models/app_user.dart

import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class AppUser extends HiveObject {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? photoUrl;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });
}

// lib/features/auth/data/models/user_model.dart

import 'package:floor/floor.dart';

import '../../domain/entities/user_entity.dart';

@Entity(tableName: 'user') // Explicitly name the table
class UserModel {
  @PrimaryKey()
  final int id;
  final String name;
  final String email;
  final double? balance;

  // A normal constructor for Floor to use.
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.balance,
  });

  // Factory to create a UserModel from JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'] == null ? null : double.tryParse(json['balance'].toString()),
    );
  }

  // A method to convert the Data Model into a Domain Entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      balance: balance,
    );
  }
}
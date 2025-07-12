import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsbimbel/databasehelp.dart';

class Admin {
  final int? id;
  final String username;
  final String userType = 'admin';
  final String password;
  final databaseHelper = DatabaseHelper();

  Admin({
    this.id,
    required this.username,
    required this.password,
  });

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
    Map<String, dynamic> toMap() {
    return {
      'id': id, // Optional: id might be null, it's handled automatically by SQLite
      'username': username,
      'userType': userType,
      'password': password,
    };
  }

}

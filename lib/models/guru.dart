import 'package:flutter/material.dart';
import 'package:utsbimbel/databasehelp.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Guru extends StatelessWidget {
  final int? id;
  final String namaGuru;
  final String userType = 'teacher';
  final String mataPelajaran;
  final String icon;
  final String username;
  final String password;
  final Uint8List? profilePicture;
  
  
  final databaseHelper = DatabaseHelper();


  Guru({
    super.key,
    this.id,
    // this.userType = 'teacher',
    required this.namaGuru,
    required this.mataPelajaran,
    required this.icon,
    required this.username,
    required this.password,
    required this.profilePicture,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaGuru': namaGuru,
      'mataPelajaran' : mataPelajaran,
      'icon': icon,
      'username': username,
      'password': password,
      'profilePicture': profilePicture
    };
  }

  // Create a Guru object from a Map
  factory Guru.fromMap(Map<String, dynamic> map) {
    return Guru(
      id: map['id'],
      namaGuru: map['namaGuru'],
      mataPelajaran: map['mataPelajaran'],
      icon: map['icon'],
      username: map['username'],
      password: map['password'],
      profilePicture: map['profilePicture'],
    );
  }

  // Add a new class to the database
  // void addGuru() async {
  //   Guru newGuru = Guru(namaGuru: 'Thobias', mataPelajaran: 'ipa', icon: 'school', username: ,);
  //   await databaseHelper.insertGuru(newGuru); // Ensure this method exists in `DatabaseHelper`
  //   print('Guru added!');
  // }

  // Get the IconData from a string
  IconData getIconData() {
    switch (icon) {
      case 'school':
        return Icons.school;
      case 'book':
        return Icons.book;
      default:
        return Icons.help; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      color: Colors.amberAccent,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(id.toString()),
            Text(namaGuru),
            Icon(
              getIconData(), // Use the string-to-icon mapping
              size: 35,
            )
          ],
        ),
      ),
    );
  }
}

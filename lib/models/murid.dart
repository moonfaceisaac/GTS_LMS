import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsbimbel/databasehelp.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Murid extends StatelessWidget {
  final int? id;
  final String namaMurid;
  final String alamat;
  final String userType = 'student';
  final int kelasId;
  final String tanggalLahir;
  final String username; // New: Username for login
  final String password;
  final Uint8List? profilePicture; // New: Password for login
  final databaseHelper = DatabaseHelper();

  Murid({
    super.key,
    this.id,
    required this.namaMurid,
    required this.alamat,
    required this.kelasId,
    required this.tanggalLahir,
    required this.username,
    required this.password,
    required this.profilePicture,
  });

  // Convert a Murid into a Map for inserting into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaMurid': namaMurid,
      'alamat': alamat,
      'kelasId': kelasId,
      'tanggalLahir': tanggalLahir,
      'username': username,
      'password': password,
      'profilePicture': profilePicture
    };
  }

  // Create a Murid from a Map
  factory Murid.fromMap(Map<String, dynamic> map) {
    return Murid(
      id: map['id'],
      namaMurid: map['namaMurid'],
      alamat: map['alamat'],
      kelasId: map['kelasId'],
      tanggalLahir: map['tanggalLahir'],
      username: map['username'],
      password: map['password'],
      profilePicture: map['profilePicture'],
    );
  }


static Future<Uint8List> optimizeImage(Uint8List imageBytes) async {
  return await FlutterImageCompress.compressWithList(
    imageBytes,
    quality: 10, // Reduce quality to lower file size
  );
}

  static Future<Uint8List> imageToBytes(File imageFile) async {
    return await imageFile.readAsBytes(); // Read the file as bytes
  }

  // Convert BLOB back to an image (if needed)
  static Widget byteArrayToImage(Uint8List byteArray) {
    return Image.memory(byteArray); // Convert byte array to an image widget
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
            Text(namaMurid),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:utsbimbel/databasehelp.dart';

class Kelas extends StatelessWidget {
  final int? id;
  final String namaKelas;
  final String icon; // Store icon as string
  final databaseHelper = DatabaseHelper();

  Kelas({
    super.key,
    this.id,
    required this.namaKelas,
    required this.icon,
  });

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaKelas': namaKelas,
      'icon': icon,
    };
  }

  // Create a Kelas object from a Map
  factory Kelas.fromMap(Map<String, dynamic> map) {
    return Kelas(
      id: map['id'],
      namaKelas: map['namaKelas'],
      icon: map['icon'],
    );
  }

  // Add a new class to the database
  void addKelas() async {
    Kelas newKelas = Kelas(namaKelas: 'Mathematics', icon: 'school');
    await databaseHelper.insertKelas(newKelas); // Ensure this method exists in `DatabaseHelper`
    print('Kelas added!');
  }

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
            Text(namaKelas),
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

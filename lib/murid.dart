// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:utsbimbel/databasehelp.dart';

// class Murid extends StatelessWidget{
//   final int? id;
//   final String namaMurid;
//   final String alamat;
//   final int kelasId; // The class the student belongs to
//   final String tanggalLahir;
//   final databaseHelper = DatabaseHelper(); // Birthdate of the student

//   Murid({
//     super.key,
//     this.id,
//     required this.namaMurid,
//     required this.alamat,
//     required this.kelasId,
//     required this.tanggalLahir,
//   });

//   // Convert a Murid into a Map for inserting into the database
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'namaMurid': namaMurid,
//       'alamat': alamat,
//       'kelasId': kelasId,
//       'tanggalLahir': tanggalLahir,
//     };
//   }

//   // Create a Murid from a Map
//   factory Murid.fromMap(Map<String, dynamic> map) {
//     return Murid(
//       id: map['id'],
//       namaMurid: map['namaMurid'],
//       alamat: map['alamat'],
//       kelasId: map['kelasId'],
//       tanggalLahir: map['tanggalLahir'],
//     );
//   }

  

//   // // Add a new class to the database
//   // void addMurid() async {
//   //   Murid newMurid = Murid(namaMurid: 'Samuel', alamat: 'helvetia', kelasId: '2');
//   //   await databaseHelper.insertGuru(newGuru); // Ensure this method exists in `DatabaseHelper`
//   //   print('Guru added!');
//   // }

//   // Get the IconData from a string
//   // IconData getIconData() {
//   //   switch (icon) {
//   //     case 'school':
//   //       return Icons.school;
//   //     case 'book':
//   //       return Icons.book;
//   //     default:
//   //       return Icons.help; // Default icon
//   //   }
//   // }

//   // @overridea
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 4,
//       color: Colors.amberAccent,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         width: 100,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(id.toString()),
//             Text(namaMurid),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // // class Murid {
// // //   String id;
// // //   String nama;
// // //   String kelas;
// // //   String alamat;
// // //   String noHP;
// // //   String asalSekolah;

// // //   Murid({
// // //     required this.id,
// // //     required this.nama,
// // //     required this.kelas,
// // //     required this.alamat,
// // //     required this.noHP,
// // //     required this.asalSekolah,
// // //   });

// // //   // Mengonversi objek Murid menjadi Map untuk disimpan ke Firestore
// // //   Map<String, dynamic> toMap() {
// // //     return {
// // //       'nama': nama,
// // //       'kelas': kelas,
// // //       'alamat': alamat,
// // //       'noHP': noHP,
// // //       'asalSekolah': asalSekolah,
// // //     };
// // //   }

// // //   // Mengonversi Map Firestore ke objek Murid
// // //   factory Murid.fromFirestore(Map<String, dynamic> firestore) {
// // //     return Murid(
// // //       id: firestore['id'],
// // //       nama: firestore['nama'],
// // //       kelas: firestore['kelas'],
// // //       alamat: firestore['alamat'],
// // //       noHP: firestore['noHP'],
// // //       asalSekolah: firestore['asalSekolah'],
// // //     );
// // //   }
// // // }
// // import 'package:sqflite/sqflite.dart';
// // import 'package:path/path.dart';

// // class Murid {
// //   final int id;
// //   final String nama;
// //   final String kelas;
// //   final String alamat;
// //   final String noHp;
// //   final String asalSekolah;

// //   Murid({required this.id, required this.nama, required this.kelas,required this.alamat,required this.noHp, required this.asalSekolah});

// //   // Convert UserData object into a map to store in SQLite
// //   Map<String, dynamic> toMap() {
// //     return {
// //       'id': id,
// //       'nama': nama,
// //       'kelas': kelas,
// //       'alamat': alamat,
// //       'No Hp': noHp,
// //       'Asal Sekolah': asalSekolah,
// //     };
// //   }
// // }

// // class DatabaseHelper {
// //   static Future<Database> getDatabase() async {
// //     return openDatabase(
// //       join(await getDatabasesPath(), 'user_data.db'),
// //       onCreate: (db, version) {
// //         return db.execute(
// //           "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)",
// //         );
// //       },
// //       version: 1,
// //     );
// //   }

// //   static Future<void> insertUser(Murid user) async {
// //     final db = await getDatabase();
// //     await db.insert(
// //       'users',
// //       user.toMap(),
// //       conflictAlgorithm: ConflictAlgorithm.replace,
// //     );
// //   }

// //   static Future<List<Murid>> getUsers() async {
// //     final db = await getDatabase();
// //     final List<Map<String, dynamic>> maps = await db.query('users');
// //     return List.generate(maps.length, (i) {
// //       return Murid(
// //         id: maps[i]['id'],
// //         nama: maps[i]['nama'],
// //         kelas: maps[i]['kelas'],
// //         alamat: maps[i]['alamat'],
// //         noHp: maps[i]['noHp'],
// //         asalSekolah: maps[i]['asalSekolah'],
// //       );
// //     });
// //   }
// // }
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class UserData {
//   final int id;
//   final String name;
//   final String email;

//   UserData({required this.id, required this.name, required this.email});

//   // Convert UserData object into a map to store in SQLite
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//     };
//   }
// }

// class DatabaseHelper {
//   static Future<Database> getDatabase() async {
//     return openDatabase(
//       join(await getDatabasesPath(), 'user_data.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)",
//         );
//       },
//       version: 1,
//     );
//   }

//   static Future<void> insertUser(UserData user) async {
//     final db = await getDatabase();
//     await db.insert(
//       'users',
//       user.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<UserData>> getUsers() async {
//     final db = await getDatabase();
//     final List<Map<String, dynamic>> maps = await db.query('users');
//     return List.generate(maps.length, (i) {
//       return UserData(
//         id: maps[i]['id'],
//         name: maps[i]['name'],
//         email: maps[i]['email'],
//       );
//     });
//   }
// }


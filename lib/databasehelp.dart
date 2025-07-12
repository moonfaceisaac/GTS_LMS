import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:utsbimbel/models/pembayaran.dart';
import 'models/kelas.dart';
import 'models/guru.dart';
import 'models/murid.dart';
import 'models/admin.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kelas.db');
    return await openDatabase(
      path,
      version: 11, // Increment version for schema updates
      onCreate: (db, version) async {
        // Create the kelas table
        db.execute('''
        CREATE TABLE kelas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namaKelas TEXT,
          icon TEXT
        )
      ''');
        db.execute(
          'CREATE TABLE admin(id INTEGER PRIMARY KEY,username TEXT, userType TEXT, password TEXT)',
        );
        await db.rawInsert(
          'INSERT INTO admin(username, userType, password) VALUES (?, ?, ?)',
          ['admin1', 'admin', 'adminpassword'],
        );

        // Create the guru table
        db.execute('''
  CREATE TABLE guru (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    namaGuru TEXT,
    userType TEXT,
    mataPelajaran TEXT,
    icon TEXT,
    password TEXT,
    username TEXT,
    profilePicture BLOB
  )
''');
        // await db.rawInsert(
        //   'INSERT INTO guru (username, userType, password) VALUES (?, ?, ?)',
        //   ['guru1', 'teacher', 'password'],
        // );
        // Create the murid table
        db.execute('''
        CREATE TABLE murid (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namaMurid TEXT NOT NULL,
          alamat TEXT NOT NULL,
          kelasId INTEGER,
          tanggalLahir TEXT,
          username TEXT,
          password TEXT,
          profilePicture BLOB,
          userType TEXT,
          FOREIGN KEY(kelasId) REFERENCES kelas(id)
        )
      ''');
        db.execute('''
          CREATE TABLE attendance (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namaMurid TEXT NOT NULL,
          muridId INTEGER,
          kelasId INTEGER,
          date TEXT,
          isPresent INTEGER,
          FOREIGN KEY (muridId) REFERENCES murid(id),
          FOREIGN KEY (namaMurid) REFERENCES murid(namaMurid),
          FOREIGN KEY (kelasId) REFERENCES kelas(id)
        )
      ''');
        db.execute('''
          CREATE TABLE pembayaran (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          muridId INTEGER,
          bulan TEXT,
          metodePembayaran TEXT,
          status TEXT,
          tanggalPembayaran DATE,
          batasPembayaran DATE,
          total INTEGER,
          FOREIGN KEY (muridId) REFERENCES murid(id)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('''
          CREATE TABLE guru (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaGuru TEXT NOT NULL,
            mataPelajaran TEXT NOT NULL,
            icon TEXT
          )
        ''');
        }
        if (oldVersion < 3) {
          db.execute('''
          CREATE TABLE murid (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            namaMurid TEXT NOT NULL,
            alamat TEXT NOT NULL,
            kelasId INTEGER,
            tanggalLahir TEXT,
            FOREIGN KEY(kelasId) REFERENCES kelas(id)
          )
        ''');
        }
        if (oldVersion < 4) {
          db.execute('''
          CREATE TABLE attendance (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          namaMurid TEXT NOT NULL,
          muridId INTEGER,
          kelasId INTEGER,
          date TEXT,
          isPresent INTEGER,
          FOREIGN KEY (muridId) REFERENCES murid(id),
          FOREIGN KEY (namaMurid) REFERENCES murid(namaMurid),
          FOREIGN KEY (kelasId) REFERENCES kelas(id)
        )
      ''');
        }
        if (oldVersion < 5) {
          // Increment schema version as needed
          db.execute('ALTER TABLE attendance ADD COLUMN namaMurid TEXT');
        }
        if (oldVersion < 6) {
          // Add multiple columns for version 2 upgrade
          db.execute("ALTER TABLE murid ADD COLUMN username TEXT");
          db.execute("ALTER TABLE murid ADD COLUMN password TEXT");
        }
        if (oldVersion < 7) {
          db.execute('''
  CREATE TABLE guru (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    namaGuru TEXT NOT NULL,
    userType TEXT,
    mataPelajaran TEXT NOT NULL,
    icon TEXT,
    password TEXT,
    username TEXT
  )
''');
        }
        if (oldVersion < 8) {
          // Add multiple columns for version 2 upgrade
          db.execute("ALTER TABLE murid ADD COLUMN profilePicture BLOB");
        }

        if (oldVersion < 9) {
          print("Forced upgrade from version $oldVersion to $newVersion");
          // Add your logic here
        }
        if (oldVersion < 10) {
          // Add multiple columns for version 2 upgrade
          db.execute("ALTER TABLE guru ADD COLUMN profilePicture BLOB");
        }
        if (oldVersion < 11) {
          // Add multiple columns for version 2 upgrade
          db.execute('''
CREATE TABLE pembayaran (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  muridId INTEGER,
  bulan TEXT,
  metodePembayaran TEXT,
  status TEXT,
  tanggalPembayaran DATE,
  batasPembayaran DATE,
  total INTEGER,
  FOREIGN KEY (muridId) REFERENCES murid(id)
  
  
)

''');
        }
      },
    );
  }

  //  required this.muridId,
  //   required this.bulan,
  //   required this.metodePembayaran,
  //   required this.status,
  //   required this.tanggalPembayaran,
  //   required this.batasPembayaran,
  //   required this.total
//   Admin newAdmin = Admin(
//   username: 'admin1',
//   password: 'password123',
// );

// // Insert the Admin into the database
// DatabaseHelper.insertAdmin(newAdmin);
  Future<void> checkDatabaseVersion() async {
    final db = await _initDatabase();
    final version = await db.getVersion();
    print("Current database version: $version");
  }
  Future<void> checkTableContents() async {
  var db = await DatabaseHelper._instance.database;
  
  // Query all rows from 'pembayaran' table
  List<Map<String, dynamic>> result = await db.query('pembayaran');
  
  // Print all rows
  result.forEach((row) {
    print(row);
  });
}

  Future<void> insertAdmin(Admin admin) async {
    final db = await database;

    // Convert Admin object to Map
    Map<String, dynamic> adminMap = admin.toMap();

    // Insert the admin into the 'admins' table
    await db.insert(
      'admin',
      adminMap,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // If conflict, replace the existing one
    );
  }

  // Future _createDB(Database db, int version) async {
  //   await db.execute('''
  //   CREATE TABLE users (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     username TEXT NOT NULL,
  //     password TEXT NOT NULL,
  //     userType TEXT NOT NULL
  //   )
  //   ''');
  // }
  Future<Admin?> getAdminByUsernameAndPassword(
      String username, String password) async {
    final db = await database;

    // Query the 'admins' table for a user with the given username and password
    List<Map<String, dynamic>> result = await db.query(
      'admin',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return Admin.fromMap(result.first); // Convert Map to Admin object
    }
    return null; // Return null if no admin is found
  }

  Future<Murid?> getMuridByUsernameAndPassword(
      String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'murid',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return Murid.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Guru?> getGuruByUsernameAndPassword(
      String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'guru',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return Guru.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<void> checkTableExistence(String tableName) async {
    final db = await database; // Use the getter
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );

    if (result.isNotEmpty) {
      print("Table '$tableName' exists.");
    } else {
      print("Table '$tableName' does NOT exist.");
    }
  }

  Future<void> resetDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'kelas.db');

    // Close the existing database connection
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Delete the database file
    await deleteDatabase(path);

    // Reinitialize the database
    await _initDatabase();
    print("Database reset successfully.");
  }

  Future<int> insertKelas(Kelas kelas) async {
    final db = await database;
    return await db.insert('kelas', kelas.toMap());
  }

  Future<int> insertPembayaran(Pembayaran pembayaran) async {
    final db = await database;
    return await db.insert('pembayaran', pembayaran.toMap());
  }

  Future<int> deletePembayaran(int id) async {
    final db = await database;
    return await db.delete('pembayaran', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<Pembayaran>> getPembayaranByMuridId(int? muridId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('pembayaran', where: 'muridId = ?', whereArgs: [muridId]);

    return List.generate(maps.length, (i) {
      return Pembayaran.fromMap(maps[i]);
      // id: maps[i]['id'],
      // namaMurid: maps[i]['namaMurid'],
      // alamat: maps[i]['alamat'],
      // tanggalLahir: maps[i]['tanggalLahir'],
      // kelasId: maps[i]['classId'],
    });
  }

  Future<List<Kelas>> getAllKelas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kelas');
    return List.generate(maps.length, (i) => Kelas.fromMap(maps[i]));

    // final db = await database;
    // return await db.update(
    //   'kelas',
    //   kelas.toMap(),
    //   where: 'id = ?',
    //   whereArgs: [kelas.id],
    // )
  }

  // Future<int> updateKelas(Kelas kelas) async {
  //   final db = await database;
  //   return await db
  //       .update("kelas", kelas.toMap(), where: 'id = ?', whereArgs: [kelas.id]);
  // }
  Future<int> updateKelas(int id, Map<String, dynamic> kelasData) async {
    final db = await database;
    return await db.update(
      'kelas',
      kelasData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteKelas(int id) async {
    final db = await database;
    return await db.delete('kelas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertGuru(Guru guru) async {
    final db = await database;
    return await db.insert('guru', guru.toMap());
  }

  // Future<List<Guru>> getAllGuru() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query('guru');
  //   return List.generate(maps.length, (i) => Guru.fromMap(maps[i]));
  // }
  Future<List<Guru>> getAllGuru() async {
    final db = await _initDatabase();

    // Query all columns except profilePicture
    final List<Map<String, dynamic>> maps = await db.query(
      'guru',
      columns: [
        'id',
        'namaGuru',
        'mataPelajaran',
        'icon',
        'username',
        'password'
      ],
    );

    // Convert the query result into a list of Murid objects
    return List.generate(maps.length, (i) {
      return Guru.fromMap(maps[i]);
    });
  }

  Future<int> updateGuru(int id, Map<String, dynamic> guruData) async {
    final db = await database;
    return await db.update(
      'guru',
      guruData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteGuru(int id) async {
    final db = await database;
    return await db.delete(
      'guru',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMurid(Murid murid) async {
    final db = await _initDatabase();
    await db.insert(
      'murid',
      murid.toMap(),
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace if the record already exists
    );
  }

  // Future<List<Murid>> getAllMurid() async {
  //   final db = await _initDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query('murid');

  //   return List.generate(maps.length, (i) {
  //     return Murid.fromMap(maps[i]);
  //   });
  // }
  Future<List<Murid>> getAllMurid() async {
    final db = await _initDatabase();

    // Query all columns except profilePicture
    final List<Map<String, dynamic>> maps = await db.query(
      'murid',
      columns: [
        'id',
        'namaMurid',
        'alamat',
        'kelasId',
        'tanggalLahir',
        'username',
        'password'
      ],
    );

    // Convert the query result into a list of Murid objects
    return List.generate(maps.length, (i) {
      return Murid.fromMap(maps[i]);
    });
  }

  Future<int> updateMurid(int id, Map<String, dynamic> muridData) async {
    final db = await database;
    return await db.update(
      'murid',
      muridData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMurid(int id) async {
    final db = await database;
    return await db.delete(
      'murid',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Murid>> getStudentsByClassId(int? classId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('murid', where: 'kelasId = ?', whereArgs: [classId]);

    return List.generate(maps.length, (i) {
      return Murid.fromMap(maps[i]);
      // id: maps[i]['id'],
      // namaMurid: maps[i]['namaMurid'],
      // alamat: maps[i]['alamat'],
      // tanggalLahir: maps[i]['tanggalLahir'],
      // kelasId: maps[i]['classId'],
    });
  }

  Future<Murid> fetchMuridById(int? id) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> results =
        await db.query('murid', where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return Murid.fromMap(results.first); // Convert Map to Murid object
    } else {
      throw Exception('Murid not found');
    }
  }

  Future<Guru> fetchGuruById(int? id) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> results =
        await db.query('guru', where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return Guru.fromMap(results.first); // Convert Map to Murid object
    } else {
      throw Exception('Guru not found');
    }
  }

  Future<void> updateAttendance({
    required int muridId,
    required int kelasId,
    required String namaMurid,
    required bool isPresent,
  }) async {
    final db = await _initDatabase();

    // Check if an attendance record already exists for this student and class
    final existingRecord = await db.query(
      'attendance',
      where: 'muridId = ? AND kelasId = ?',
      whereArgs: [muridId, kelasId],
    );

    if (existingRecord.isNotEmpty) {
      // Update existing record
      await db.update(
        'attendance',
        {'isPresent': isPresent ? 1 : 0},
        where: 'muridId = ? AND kelasId = ?',
        whereArgs: [muridId, kelasId],
      );
    } else {
      // Insert new record
      await db.insert('attendance', {
        'muridId': muridId,
        'kelasId': kelasId,
        'namaMurid': namaMurid,
        'date': DateTime.now().toIso8601String(),
        'isPresent': isPresent ? 1 : 0,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceForClass(int? kelasId) async {
    final db = await _initDatabase();
    return await db.query(
      'attendance',
      where: 'kelasId = ?',
      whereArgs: [kelasId],
    );
  }

// Future<void> fetchAndPrintMurid() async {
//   final db = await openDatabase('your_database.db'); // Replace with your actual database name

//   // Query to fetch all Murid records
//   List<Map<String, dynamic>> muridList = await db.query('murid'); // Replace 'murid' with your table name

//   // Print each Murid record to the console
//   for (var muridMap in muridList) {
//     Murid murid = Murid.fromMap(muridMap);
//     print('Murid ID: ${murid.id}, Name: ${murid.namaMurid}, Kelas ID: ${murid.kelasId}');
//   }
// }

  // Future<int> registerUser(String username, String password, String userType) async {
  //   final db = await _instance.database;
  //   return await db.insert('users', {
  //     'username': username,
  //     'password': password,
  //     'userType': userType,
  //   });
  // }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await _instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }
}

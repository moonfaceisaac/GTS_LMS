import 'dart:typed_data';
import 'dart:ui';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsbimbel/models/kelas.dart';
import 'package:utsbimbel/models/guru.dart';
import 'package:utsbimbel/models/murid.dart';
import 'package:utsbimbel/login.dart';
import 'package:utsbimbel/databasehelp.dart';
import 'package:utsbimbel/screens/pembayaranmurid.dart';

class HomeMurid extends StatefulWidget {
  final Murid murid;
  const HomeMurid({super.key, required this.murid});

  @override
  State<HomeMurid> createState() => _HomeMuridState();
}

class _HomeMuridState extends State<HomeMurid> {
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Singleton instance
  List<Kelas> _kelasList = [];
  List<Guru> _guruList = [];
  List<Murid> _muridList = [];
  List<Murid> _muridListByClass = [];
  List<Map<String, dynamic>> _attendanceList = [];
  Guru? _selectedGuru;
  Kelas? _selectedKelas;
  int? classid;
  bool _isTeacherSelected = true;

  @override
  void initState() {
    super.initState();
    _fetchKelasList();
    _fetchGuruList();
    _fetchMuridList();
    // if (_selectedKelas != null) {
    //   _loadAttendance();
    // }
    // Fetch data when the widget initializes
  }

  // Fetch the list of classes from the database
  void _fetchKelasList() async {
    List<Kelas> fetchedList = await _databaseHelper.getAllKelas();
    setState(() {
      _kelasList = fetchedList;
    });
  }

  void _fetchGuruList() async {
    List<Guru> fetchedList = await _databaseHelper.getAllGuru();
    setState(() {
      _guruList = fetchedList;
    });
  }

  void _fetchMuridList() async {
    List<Murid> fetchedList = await _databaseHelper.getAllMurid();
    setState(() {
      _muridList = fetchedList;
    });
  }

  void _fetchMuridListByClass(int? classid) async {
    List<Murid> fetchedList =
        await _databaseHelper.getStudentsByClassId(classid);
    setState(() {
      _muridListByClass = fetchedList;
    });
  }

  void _loadAttendance() async {
    if (_selectedKelas != null) {
      debugPrint('selectedKelas is not null');
      final attendanceData =
          await _databaseHelper.getAttendanceForClass(_selectedKelas!.id);
      debugPrint(attendanceData.toString());
      setState(() {
        _attendanceList = attendanceData;
        debugPrint('///////////////////////////////////////////');
        debugPrint(_attendanceList.toString());
      });
    }
  }

  void fetchAttendance(int kelasId) async {
    try {
      List<Map<String, dynamic>> attendanceRecords =
          await _databaseHelper.getAttendanceForClass(kelasId);
      // Do something with the attendance records, like displaying them in a UI
      debugPrint(attendanceRecords.toString());
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<Map<String, dynamic>> fetchMuridBiodata(int muridId) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    return {
      'nama': 'John Doe',
      'alamat': 'Jl. Kebon Jeruk No. 27',
      'tanggalLahir': '2005-05-12',
      'kelas': '10A'
    }; // Sample data
  }

// Future<List<Murid>> FetchBio(int muridId) async {
//   await Future.delayed(Duration(seconds: 2));
//   final resultBio =
//   return
// }
  // void _fetchMuridListByClass() async {
  //   List<Murid> fetchedList = await _databaseHelper.getStudentsByClassId();
  //   setState(() {
  //     _muridList = fetchedList;
  //   });
  // }

  // void _fetchData() async {
  //   List<Guru> fetchedGuruList = await _databaseHelper.getAllGuru();
  //   List<Murid> fetchedMuridList = await _databaseHelper.getAllMurid();
  //   setState(() {
  //     _guruList = fetchedGuruList;
  //     _muridList = fetchedMuridList;
  //   });
  // }

  void _onFilterChanged(String? value) {
    setState(() {
      if (value == 'Guru') {
        _isTeacherSelected = true;
      } else if (value == 'Murid') {
        _isTeacherSelected = false;
      }
    });
  }

// ListView.builder(
//                             itemCount: _muridListByClass.length,
//                             itemBuilder: (context, index) {
//                               Murid murid = _muridListByClass[index];
//                               return ListTile(
//                                 title: Text(murid.namaMurid),
//                                 subtitle: Text("ID: ${murid.id ?? 'N/A'}"),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize
//                                       .min, // This ensures the row only takes up as much space as needed
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.check,
//                                           color: Colors.green),
//                                       onPressed: () async {
//                                         if (_selectedKelas != null) {
//                                           await _databaseHelper.updateAttendance(
//                                             muridId: murid.id!,
//                                             kelasId: _selectedKelas!.id!, // Use the null check operator here
//                                             isPresent: true,
//                                           );
//                                           debugPrint(
//                                               "${murid.namaMurid} marked as present");
//                                         } else {
//                                           // Handle the case where no class is selected
//                                           debugPrint("No class selected.");
//                                         }
//                                       },
//                                     ),
  void _showAttendanceDialog() {
    _loadAttendance();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Daftar Kehadiran"),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                final attendance = _attendanceList[index];
                final muridName = attendance[
                    'namaMurid']; // Adjust based on your table columns
                final isPresent = attendance[
                    'isPresent']; // Adjust based on your table columns

                return ListTile(
                  title: Text(muridName ?? 'No Name'),
                  subtitle: Text("ID: ${attendance['muridId']}"),
                  trailing: Icon(
                    isPresent == 1 ? Icons.check : Icons.close,
                    color: isPresent == 1 ? Colors.green : Colors.red,
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BERANDA MURID"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text(
                'BIMBEL HCK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle Home navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle Settings navigation
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                // Handle Settings navigation
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: _kelasList.isEmpty
          ? FutureBuilder<Murid>(
              future: _databaseHelper.fetchMuridById(widget.murid.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  print('///////////////////////////');
                  print(snapshot.data);
                  return Text('Error : Unknown ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final murid = snapshot.data;
                  if (murid != null) {
                    return MuridBio(
                        murid: murid,
                        namaMurid: murid.namaMurid,
                        alamat: murid.alamat,
                        tanggalLahir: murid.tanggalLahir,
                        profpic: murid.profilePicture!);
                  }
                }
                return Text('Data tidak ditemukan');
              })
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FutureBuilder<Murid>(
                      future: _databaseHelper.fetchMuridById(widget.murid.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error : Unknown ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final murid = snapshot.data;
                          if (murid != null) {
                            return MuridBio(
                              murid: murid,
                              namaMurid: murid.namaMurid,
                              alamat: murid.alamat,
                              tanggalLahir: murid.tanggalLahir,
                              profpic: murid.profilePicture!,
                            );
                          }
                        }

                        return Text('Data tidak ditemukan');
                      }),
                  const Text('Kelas anda'),
                  const Divider(),
                  SizedBox(
                    width: 500,
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _kelasList.length,
                      itemBuilder: (context, index) {
                        Kelas kelas = _kelasList[index];

                        return GestureDetector(
                          onTap: () {
                            // Handle the click action here
                            debugPrint("Selected Kelas: ${kelas.namaKelas}");
                            setState(() {
                              _selectedKelas = kelas;
                              _loadAttendance();
                              _fetchMuridListByClass(_selectedKelas!.id);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: _selectedKelas == kelas
                                  ? Colors.blueAccent
                                  : Colors.amberAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Kelas(
                              id: kelas.id,
                              namaKelas: kelas.namaKelas,
                              icon: kelas.icon,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Class details card
                  Card(
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _selectedKelas == null
                              ? const Center(
                                  child: Text(
                                    "Silahkan Pilih Kelas",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              :
                              //  SizedBox(
                              //         width: 400,
                              //         height: 100,
                              //         child: ListView.builder(
                              //           itemCount: _muridListByClass.length,
                              //           itemBuilder: (context, index) {
                              //             Murid murid = _muridListByClass[index];
                              //             return ListTile(
                              //               title: Text(murid.namaMurid),
                              //               subtitle:
                              //                   Text("ID: ${murid.id ?? 'N/A'}"),
                              //               // selected: _selectedGuru ==
                              //               //     guru, // Mark the selected teacher
                              //               onTap: () {
                              //                 setState(() {
                              //                   // _selectedMurid = murid;
                              //                 });
                              //                 debugPrint(
                              //                     "Selected: ${murid.namaMurid}");
                              //               },
                              //             );
                              //           },
                              //         ),
                              //       )

                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      _getIconFromName(_selectedKelas!.icon),
                                      size: 50,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ${_selectedKelas!.namaKelas}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "ID: ${_selectedKelas!.id ?? 'N/A'}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const Text(
                                          "Rinci:...",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _showAttendanceDialog();
                                            });
                                            // Show the attendance dialog when clicked
                                          },
                                          child: const Text("Tampilkan Kehadiran"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  // Action buttons
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     MaterialButton(
                  //       onPressed: () {
                  //         // if (_selectedGuru == null) {
                  //         //   // Show a message if no teacher is selected
                  //         //   ScaffoldMessenger.of(context).showSnackBar(
                  //         //     const SnackBar(
                  //         //       content: Text('Please select a teacher first.'),
                  //         //     ),
                  //         //   );
                  //         // } else {
                  //         _showAddMuridDialog();
                  //         // }
                  //       },
                  //       child: const Text("Add Murid"),
                  //     ),
                  //     MaterialButton(
                  //       onPressed: () {},
                  //       child: const Text("Add"),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
    );
  }

  // Helper function to get IconData from string
  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case "school":
        return Icons.school;
      case "book":
        return Icons.book;
      default:
        return Icons.help; // Fallback icon
    }
  }

  // void _showAddMuridDialog() {
  //   final TextEditingController namaMuridController = TextEditingController();
  //   final TextEditingController alamatController = TextEditingController();
  //   final TextEditingController tanggalLahirController =
  //       TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Add Murid"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: namaMuridController,
  //               decoration: const InputDecoration(labelText: "Nama Murid"),
  //             ),
  //             TextField(
  //               controller: alamatController,
  //               decoration: const InputDecoration(labelText: "Alamat"),
  //             ),
  //             TextField(
  //               controller: tanggalLahirController,
  //               decoration: const InputDecoration(labelText: "Tanggal Lahir"),
  //             ),
  //             DropdownButton<Kelas>(
  //               value: _selectedKelas,
  //               hint: const Text("Select Kelas"),
  //               onChanged: (Kelas? newValue) {
  //                 setState(() {
  //                   _selectedKelas = newValue;
  //                 });
  //               },
  //               items: _kelasList.map<DropdownMenuItem<Kelas>>((Kelas kelas) {
  //                 return DropdownMenuItem<Kelas>(
  //                   value: kelas,
  //                   child: Text(kelas.namaKelas),
  //                 );
  //               }).toList(),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text("Cancel"),
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               if (namaMuridController.text.isNotEmpty &&
  //                   alamatController.text.isNotEmpty &&
  //                   tanggalLahirController.text.isNotEmpty &&
  //                   _selectedKelas != null) {
  //                 // Create a new Murid object and insert it into the database
  //                 Murid newMurid = Murid(
  //                   namaMurid: namaMuridController.text,
  //                   alamat: alamatController.text,
  //                   tanggalLahir: tanggalLahirController.text,
  //                   kelasId: _selectedKelas!.id!, // Use the selected class id
  //                 );

  //                 await _databaseHelper.insertMurid(newMurid);
  //                 // _fetchKelasList();
  //                 _isTeacherSelected = false;
  //                 setState(() {});
  //                 // Refresh the list of students after adding
  //                 Navigator.of(context).pop(); // Close the dialog
  //               }
  //             },
  //             child: const Text("Add"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class MuridBio extends StatelessWidget {
  final Murid murid;
  final int? id;
  final String namaMurid;
  final String alamat;
  final String tanggalLahir;
  final Uint8List profpic;

  const MuridBio({
    super.key,
    this.id,
    required this.namaMurid,
    required this.murid,
    required this.alamat,
    required this.tanggalLahir,
    required this.profpic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 4,
      color: Colors.amberAccent,
      child: Container(
        height: 130,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            CircleAvatar(
                radius: 60,
                backgroundImage: MemoryImage(
                    profpic) // Use MemoryImage for Uint8List// No child if image is set
                ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama : $namaMurid',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Alamat : $alamat',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Tanggal Lahir : $tanggalLahir',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Pembayaranmurid(murid: murid)));
                    },
                    child: Text('Pembayaran'))
              ],
            )
          ]),
        ),
      ),
    );
  }
}

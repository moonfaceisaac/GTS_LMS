//---PACKAGES--

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:utsbimbel/models/admin.dart';
import 'package:utsbimbel/models/kelas.dart';
import 'package:utsbimbel/models/guru.dart';
import 'package:utsbimbel/models/murid.dart';
import 'package:utsbimbel/databasehelp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:utsbimbel/models/pembayaran.dart';
import 'package:utsbimbel/screens/pembayaranmuridadmin.dart';

//---PACKAGES--
class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key, required Admin admin});
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

//---DECLARE
class _HomeAdminState extends State<HomeAdmin> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Kelas> _kelasList = [];
  List<Guru> _guruList = [];
  List<Murid> _muridList = [];

  Guru? _selectedGuru;
  Murid? _selectedMurid;
  Kelas? _selectedKelas;
  bool _isTeacherSelected = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController namaMuridController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final GlobalKey<FormState> _formKeyGuru = GlobalKey<FormState>();
  final TextEditingController namaGuruController = TextEditingController();
  final TextEditingController mataPelajaranController = TextEditingController();
  final TextEditingController idGuruController = TextEditingController();

  final GlobalKey<FormState> _formKeyKelas = GlobalKey<FormState>();
  final TextEditingController namaKelasController = TextEditingController();
  final TextEditingController icon = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  late Uint8List editedImageBytes;
  late Uint8List preOptimizedImageBytes;
  late Uint8List preOptimizedImageBytesGuru;
  late Uint8List preOptimizedEditedImageBytes;
  // Murid? murid = await databaseHelper.getMuridByUsernameAndPassword(
  //         username, password);

//---DECLARE
  @override
  void initState() {
    super.initState();
    _fetchKelasList();
    _fetchGuruList();
    _fetchMuridList();
  }

  //---FETCH--
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

//---FETCH--
  // static Future<Uint8List> imageToBytes(File imageFile) async {
  //   return await imageFile.readAsBytes(); // Read the file as bytes
  // }

  // // Convert BLOB back to an image (if needed)
  // static Widget byteArrayToImage(Uint8List byteArray) {
  //   return Image.memory(byteArray); // Convert byte array to an image widget
  // }

  Future<void> _pickImage(void Function(void Function()) setState) async {
    // Request photo permission
    requestPhotosPermission();

    // Check permission status
    var status = await Permission.photos.request();

    if (status.isGranted) {
      // Initialize the image picker
      // final ImagePicker _picker = ImagePicker();

      // Pick an image from the gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Update the selected image
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } else if (status.isDenied) {
      // Handle denied permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied to access photos')),
      );
    } else if (status.isPermanentlyDenied) {
      // Guide the user to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable photo access in settings')),
      );
      openAppSettings();
    }
  }

  // void _saveProfile() {
  //   // Save profile details logic here (e.g., API call, database update)
  //   print("Name: ${_nameController.text}");
  //   print("Email: ${_emailController.text}");
  //   if (_selectedImage != null) {
  //     print("Selected Image Path: ${_selectedImage!.path}");
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Profile saved successfully!')),
  //   );
  // }

  Future<void> requestPhotosPermission() async {
    PermissionStatus status = await Permission.photos.status;

    if (status.isGranted) {
      // Permission already granted
      print("Photos permission granted");
    } else if (status.isDenied) {
      // Request permission
      status = await Permission.photos.request();

      if (status.isGranted) {
        print("Photos permission granted");
      } else if (status.isPermanentlyDenied) {
        // Open app settings to enable permission
        await openAppSettings();
      } else {
        print("Photos permission denied");
      }
    } else if (status.isPermanentlyDenied) {
      // Open app settings to enable permission
      await openAppSettings();
    }
  }

//---DELETE--
  void _deleteMurid(int id) async {
    int result = await _databaseHelper.deleteMurid(id);
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Murid deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Murid')),
      );
    }
  }

  void _deleteGuru(int id) async {
    int result = await _databaseHelper.deleteGuru(id);
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Murid deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Murid')),
      );
    }
  }

  void _deleteKelas(int id) async {
    int result = await _databaseHelper.deleteKelas(id);
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kelas deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete kelas')),
      );
    }
  }
//---DELETE--

//---SAVE--
  void _saveMurid(int id) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> muridData = {
        'namaMurid': namaMuridController.text,
        'kelasId': int.tryParse(idController.text) ?? 0,
        'alamat': alamatController.text,
        'tanggalLahir': tanggalLahirController.text,
        'profilePicture': preOptimizedEditedImageBytes,
      };

      int result = await _databaseHelper.updateMurid(id, muridData);

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        setState(() {});
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update data')),
        );
      }
    }
  }

  void _saveGuru(int id) async {
    if (_formKeyGuru.currentState!.validate()) {
      // Prepare data
      Map<String, dynamic> guruData = {
        'namaGuru': namaGuruController.text,
        'mataPelajaran': mataPelajaranController.text,
        'icon': 'school',
        'profilePicture': preOptimizedImageBytesGuru,
      };
      int result = await _databaseHelper.updateGuru(id, guruData);

      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        setState(() {});
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update data')),
        );
      }
    }
  }

  void _saveKelas(int id) async {
    if (_formKeyKelas.currentState!.validate()) {
      Map<String, dynamic> kelasData = {
        'namaKelas': namaKelasController.text,
        'icon': 'school',
      };

      int result = await _databaseHelper.updateKelas(id, kelasData);
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        setState(() {});
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update data')),
        );
      }
    }
  }
//---SAVE--

  void _fetchData() async {
    List<Guru> fetchedGuruList = await _databaseHelper.getAllGuru();
    List<Murid> fetchedMuridList = await _databaseHelper.getAllMurid();
    setState(() {
      _guruList = fetchedGuruList;
      _muridList = fetchedMuridList;
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      if (value == 'Guru') {
        _isTeacherSelected = true;
      } else if (value == 'Murid') {
        _isTeacherSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Beranda Admin"),
        actions: [
          DropdownButton<String>(
            value: _isTeacherSelected ? 'Guru' : 'Murid',
            icon: const Icon(Icons.filter_list),
            onChanged: _onFilterChanged,
            items: const [
              DropdownMenuItem(
                value: 'Guru',
                child: Text('Guru'),
              ),
              DropdownMenuItem(
                value: 'Murid',
                child: Text('Murid'),
              ),
            ],
          ),
        ],
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
              leading: Icon(Icons.edit),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('DATA USER'),
            const Divider(),
            _isTeacherSelected
                ? SizedBox(
                    width: 500,
                    height: 200,
                    child: ListView.builder(
                      //line:388
                      itemCount: _guruList.length,
                      itemBuilder: (context, index) {
                        Guru guru = _guruList[index];
                        return ListTile(
                          title: Text(guru.namaGuru),
                          subtitle: Text("ID: ${guru.id ?? 'N/A'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _selectedGuru = guru;
                                    _showDetailGuruDialog(guru.id);
                                  },
                                  icon: const Icon(Icons.edit)),
                          
                            ],
                          ),
                          selected: _selectedGuru == guru,
                          onTap: () {
                            setState(() {});
                            debugPrint("Selected: ${guru.namaGuru}");
                          },
                        );
                      },
                    ),
                  )
                : SizedBox(
                    width: 500,
                    height: 200,
                    child: ListView.builder(
                      itemCount: _muridList.length,
                      itemBuilder: (context, index) {
                        Murid murid = _muridList[index];
                        return ListTile(
                          title: Text(murid.namaMurid),
                          subtitle: Text("ID: ${murid.id ?? 'N/A'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _selectedMurid = murid;
                                    _showDetailMuridDialog(murid.id);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _selectedMurid = murid;
                                    _showAddPaymentDialog(context);
                                  },
                                  icon: const Icon(Icons.payment_outlined)),
                            ],
                          ),
                          selected: _selectedMurid == murid,
                          onTap: () {
                            setState(() {
                              _selectedMurid = murid;
                            });
                            debugPrint("Selected: ${murid.namaMurid}");
                          },
                        );
                      },
                    ),
                  ),
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
                      debugPrint("Selected Kelas: ${kelas.namaKelas}");
                      setState(() {
                        _selectedKelas = kelas;
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
                              "Tidak ada kelas yang terseleksi",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _getIconFromName(_selectedKelas!.icon),
                                size: 50,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "Rincian : ...",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    _showDetailKelasDialog(_selectedKelas!.id);
                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.school),
                    title: const Text("Tambah Kelas"),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddKelasDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Tambah Guru"),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddGuruDialog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text("Tambah Murid"),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddMuridDialog();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case "school":
        return Icons.school;
      case "book":
        return Icons.book;
      default:
        return Icons.help;
    }
  }

  void _showDetailMuridDialog(int? muridID) {
    bool isEditingMode = false;

    Widget _getDialogContent(void Function(void Function()) setState) {
      int caseNumber;

      if (_selectedMurid == null) {
        caseNumber = 1;
      } else if (_selectedMurid != null && !isEditingMode) {
        caseNumber = 2;
      } else if (_selectedMurid != null && isEditingMode) {
        caseNumber = 3;
      } else {
        caseNumber = 0;
      }

      switch (caseNumber) {
        case 1:
          return const Text('Data can\'t be retrieved');
        case 2:
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 226, 226, 226),
                  ),
                  BoxShadow(
                    offset: Offset(-2.0, -2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(245, 240, 237, 237),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text("ID MURID: ${_selectedMurid!.id.toString()}"),
                    Text("NAMA MURID:${_selectedMurid!.namaMurid}"),
                    Text("KELAS MURID:${_selectedMurid!.kelasId.toString()}"),
                    Text("ALAMAT:${_selectedMurid!.alamat}"),
                    Text("TANGGAL LAHIR:${_selectedMurid!.tanggalLahir}"),
                    TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PembayaranmuridAdmin(murid : _selectedMurid!)));
                      
                    }, child: Text("Info Pembayaran")),
                  ],
                ),
              ),
            ),
          );
        case 3:
          return Form(
            key: _formKey,
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                children: [
                  const Text('MODE EDIT'),
                  TextFormField(
                    controller: namaMuridController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'tolong masukkan nama';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: alamatController,
                    decoration: const InputDecoration(labelText: 'Alamat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tolong Masukkan alamat';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: tanggalLahirController,
                    decoration:
                        const InputDecoration(labelText: 'Tanggal Lahir'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tolong Masukkan Tanggal lahir';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'Kelas ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tolong Masukkan Kelas ID';
                      }
                      return null;
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _pickImage(setState);
                      if (_selectedImage != null) {
                        // Convert image to bytes and save it to the database
                        editedImageBytes =
                            await Murid.imageToBytes(_selectedImage!);
                        preOptimizedEditedImageBytes =
                            await Murid.optimizeImage(editedImageBytes);
                        // Now you can save `imageBytes` in the `profilePicture` field of your `Murid` object
                      }
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                ],
              );
            }),
          );
        default:
          return const Text('Unknown state');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Informasi Rinci Murid'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getDialogContent(setState),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isEditingMode) ...[
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              isEditingMode = true;
                            });
                          },
                          child: const Text('Edit'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _deleteMurid(muridID!);
                            _fetchMuridList();
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus'),
                        ),
                      ] else ...[
                        MaterialButton(
                          onPressed: () {
                            final muridId = _selectedMurid?.id;

                            _saveMurid(muridId ?? 1);
                            debugPrint('////////////////////////////////////');
                            debugPrint(_formKey.currentState.toString());
                            debugPrint(_selectedMurid!.id.toString());
                            _fetchMuridList();
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Pembayaran'),
          content: AddPaymentForm(murid: _selectedMurid!),
        );
      },
    );
  }

  void _showDetailGuruDialog(int? guruID) {
    bool isEditingMode = false;

    Widget _getDialogContent() {
      int caseNumber;
      if (_selectedGuru == null) {
        caseNumber = 1;
      } else if (_selectedGuru != null && !isEditingMode) {
        caseNumber = 2;
      } else if (_selectedGuru != null && isEditingMode) {
        caseNumber = 3;
      } else {
        caseNumber = 0;
      }

      switch (caseNumber) {
        case 1:
          return const Text('Data can\'t be retrieved');
        case 2:
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
               BoxShadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 226, 226, 226),
                  ),
                  BoxShadow(
                    offset: Offset(-2.0, -2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(245, 240, 237, 237),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text("ID GURU: ${_selectedGuru!.id.toString()}"),
                    Text("NAMA GURU: ${_selectedGuru!.namaGuru}"),
                    Text("MATA PELAJARAN: ${_selectedGuru!.mataPelajaran}"),
                  ],
                ),
              ),
            ),
          );
        case 3:
          return Form(
            key: _formKeyGuru,
            child: Column(
              children: [
                const Text('MODE EDIT'),
                TextFormField(
                  controller: namaGuruController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tolong masukkan nama';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mataPelajaranController,
                  decoration:
                      const InputDecoration(labelText: 'Mata Pelajaran'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong Masukkan Mata Pelajaran';
                    }
                    return null;
                  },
                ),
              ],
            ),
          );
        default:
          return const Text('Unknown state');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Informasi Rinci Guru'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getDialogContent(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isEditingMode) ...[
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              isEditingMode = true;
                            });
                          },
                          child: const Text('Edit'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _deleteGuru(guruID!);
                            _fetchGuruList();
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus'),
                        ),
                      ] else ...[
                        MaterialButton(
                          onPressed: () {
                            final guruID = _selectedGuru?.id;

                            _saveGuru(guruID ?? 1);
                            debugPrint('////////////////////////////////////');
                            debugPrint(_formKeyGuru.currentState.toString());
                            debugPrint(_selectedGuru!.id.toString());
                            _fetchGuruList();
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDetailKelasDialog(int? kelasID) {
    bool isEditingMode = false;

    Widget _getDialogContent() {
      int caseNumber;
      if (_selectedKelas == null) {
        caseNumber = 1;
      } else if (_selectedKelas != null && !isEditingMode) {
        caseNumber = 2;
      } else if (_selectedKelas != null && isEditingMode) {
        caseNumber = 3;
      } else {
        caseNumber = 0;
      }

      switch (caseNumber) {
        case 1:
          return const Text('Data can\'t be retrieved');
        case 2:
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 226, 226, 226),
                  ),
                  BoxShadow(
                    offset: Offset(-2.0, -2.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(245, 240, 237, 237),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text("KELAS ID: ${_selectedKelas!.id.toString()}"),
                    Text("ICON: ${_selectedKelas!.icon}"),
                    Text("NAMA KELAS: ${_selectedKelas!.namaKelas}"),
                  ],
                ),
              ),
            ),
          );
        case 3:
          return Form(
            key: _formKeyKelas,
            child: Column(
              children: [
                const Text('MODE EDIT'),
                TextFormField(
                  controller: namaKelasController,
                  decoration: const InputDecoration(labelText: 'Nama Kelas'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'tolong masukkan nama kelas';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mataPelajaranController,
                  decoration:
                      const InputDecoration(labelText: 'Mata Pelajaran'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong Masukkan Mata Pelajaran';
                    }
                    return null;
                  },
                ),
              ],
            ),
          );
        default:
          return const Text('Unknown state');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Informasi Rinci Kelas'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getDialogContent(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isEditingMode) ...[
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              isEditingMode = true;
                            });
                          },
                          child: const Text('Edit'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _deleteKelas(kelasID!);
                            _fetchKelasList();
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus'),
                        ),
                      ] else ...[
                        MaterialButton(
                          onPressed: () {
                            final kelasID = _selectedKelas?.id;

                            _saveKelas(kelasID ?? 1);
                            debugPrint('////////////////////////////////////');
                            debugPrint(_formKeyKelas.currentState.toString());
                            debugPrint(_selectedKelas!.id.toString());
                            _fetchKelasList();
                          },
                          child: const Text('Simpan'),
                        ),
                      ],
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMuridDialog() {
    final TextEditingController namaMuridController = TextEditingController();
    final TextEditingController alamatController = TextEditingController();
    final TextEditingController tanggalLahirController =
        TextEditingController();
    String kelasHint = "Pilih Kelas";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Tambah Murid"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMuridController,
                  decoration: const InputDecoration(labelText: "Nama Murid"),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "username"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "password"),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: "Alamat"),
                ),
                TextField(
                  controller: tanggalLahirController,
                  decoration: const InputDecoration(labelText: "Tanggal Lahir"),
                ),
                GestureDetector(
                  onTap: () async {
                    await _pickImage(setState);
                    if (_selectedImage != null) {
                      // Convert image to bytes and save it to the database
                      Uint8List imageBytes =
                          await Murid.imageToBytes(_selectedImage!);
                      preOptimizedImageBytes =
                          await Murid.optimizeImage(imageBytes);
                      // Now you can save `imageBytes` in the `profilePicture` field of your `Murid` object
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                DropdownButton<Kelas>(
                  value: null,
                  hint: Text(kelasHint),
                  onChanged: (Kelas? newValue) {
                    setState(() {
                      _selectedKelas = newValue;
                      debugPrint(_selectedKelas!.namaKelas);
                      kelasHint = newValue!.namaKelas;
                      debugPrint("aww$kelasHint");
                    });
                  },
                  items: _kelasList.map<DropdownMenuItem<Kelas>>((Kelas kelas) {
                    return DropdownMenuItem<Kelas>(
                      value: kelas,
                      child: Text(kelas.namaKelas),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  if (namaMuridController.text.isNotEmpty &&
                      alamatController.text.isNotEmpty &&
                      tanggalLahirController.text.isNotEmpty &&
                      _selectedKelas != null &&
                      _selectedImage != null) {
                    // Uint8List? imageBytes;
                    // imageBytes =
                    //     await Murid.imageToBytes(File(_selectedImage!.path));
                    Murid newMurid = Murid(
                      username: usernameController.text,
                      password: passwordController.text,
                      namaMurid: namaMuridController.text,
                      alamat: alamatController.text,
                      tanggalLahir: tanggalLahirController.text,
                      profilePicture: preOptimizedImageBytes,
                      kelasId: _selectedKelas!.id!,
                    );

                    await _databaseHelper.insertMurid(newMurid);

                    _isTeacherSelected = false;
                    setState(() {});
                    _fetchMuridList();

                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Tambah"),
              ),
            ],
          );
        });
      },
    );
  }

  void _showAddGuruDialog() {
    final TextEditingController namaGuru2Controller = TextEditingController();
    final TextEditingController mataPelajaran2Controller =
        TextEditingController();
    final TextEditingController username2Controller = TextEditingController();
    final TextEditingController password2Controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text("Tambah Guru"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaGuru2Controller,
                  decoration: const InputDecoration(labelText: "Nama Guru"),
                ),
                TextField(
                  controller: username2Controller,
                  decoration: const InputDecoration(labelText: "username"),
                ),
                TextField(
                  controller: password2Controller,
                  decoration: const InputDecoration(labelText: "password"),
                ),
                TextField(
                  controller: mataPelajaran2Controller,
                  decoration:
                      const InputDecoration(labelText: "Mata Pelajaran"),
                ),
                GestureDetector(
                  onTap: () async {
                    await _pickImage(setState);
                    if (_selectedImage != null) {
                      // Convert image to bytes and save it to the database
                      Uint8List imageBytes =
                          await Murid.imageToBytes(_selectedImage!);
                      preOptimizedImageBytesGuru =
                          await Murid.optimizeImage(imageBytes);
                      // Now you can save `imageBytes` in the `profilePicture` field of your `Murid` object
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  if (namaGuru2Controller.text.isNotEmpty &&
                      mataPelajaran2Controller.text.isNotEmpty &&
                      username2Controller.text.isNotEmpty &&
                      password2Controller.text.isNotEmpty) {
                    Guru newGuru = Guru(
                        username: username2Controller.text,
                        password: password2Controller.text,
                        namaGuru: namaGuru2Controller.text,
                        mataPelajaran: mataPelajaran2Controller.text,
                        profilePicture: preOptimizedImageBytesGuru,
                        icon: 'school');

                    await _databaseHelper.insertGuru(newGuru);

                    _isTeacherSelected = false;
                    setState(() {});
                    _fetchGuruList();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Tambah"),
              ),
            ],
          );
        });
        // return AlertDialog(
        //   title: const Text("Tambah Guru"),
        //   content: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       TextField(
        //         controller: namaGuru2Controller,
        //         decoration: const InputDecoration(labelText: "Nama Guru"),
        //       ),
        //       TextField(
        //         controller: username2Controller,
        //         decoration: const InputDecoration(labelText: "username"),
        //       ),
        //       TextField(
        //         controller: password2Controller,
        //         decoration: const InputDecoration(labelText: "password"),
        //       ),
        //       TextField(
        //         controller: mataPelajaran2Controller,
        //         decoration: const InputDecoration(labelText: "Mata Pelajaran"),
        //       ),
        //       GestureDetector(
        //         onTap: () async {
        //           await _pickImage(setState);
        //           if (_selectedImage != null) {
        //             // Convert image to bytes and save it to the database
        //             Uint8List imageBytes =
        //                 await Murid.imageToBytes(_selectedImage!);
        //             preOptimizedImageBytesGuru =
        //                 await Murid.optimizeImage(imageBytes);
        //             // Now you can save `imageBytes` in the `profilePicture` field of your `Murid` object
        //           }
        //         },
        //         child: CircleAvatar(
        //           radius: 50,
        //           backgroundImage: _selectedImage != null
        //               ? FileImage(_selectedImage!)
        //               : null,
        //           child: _selectedImage == null
        //               ? Icon(Icons.camera_alt, size: 50)
        //               : null,
        //         ),
        //       ),
        //     ],
        //   ),
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //       child: const Text("Batal"),
        //     ),
        //     TextButton(
        //       onPressed: () async {
        //         if (namaGuru2Controller.text.isNotEmpty &&
        //             mataPelajaran2Controller.text.isNotEmpty &&
        //             username2Controller.text.isNotEmpty &&
        //             password2Controller.text.isNotEmpty) {
        //           Guru newGuru = Guru(
        //               username: username2Controller.text,
        //               password: password2Controller.text,
        //               namaGuru: namaGuru2Controller.text,
        //               mataPelajaran: mataPelajaran2Controller.text,
        //               profilePicture: preOptimizedImageBytesGuru,
        //               icon: 'school');

        //           await _databaseHelper.insertGuru(newGuru);

        //           _isTeacherSelected = false;
        //           setState(() {});
        //           _fetchGuruList();
        //           Navigator.of(context).pop();
        //         }
        //       },
        //       child: const Text("Tambah"),
        //     ),
        //   ],
        // );
      },
    );
  }

  void _showAddKelasDialog() {
    final TextEditingController namaKelasController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Kelas"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaKelasController,
                decoration: const InputDecoration(labelText: "Nama Kelas"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                if (namaKelasController.text.isNotEmpty) {
                  Kelas newKelas = Kelas(
                      namaKelas: namaKelasController.text, icon: 'school');

                  await _databaseHelper.insertKelas(newKelas);

                  _isTeacherSelected = false;
                  setState(() {});
                  _fetchKelasList();

                  Navigator.of(context).pop();
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }
}

class AddPaymentForm extends StatefulWidget {
  final Murid murid;

  const AddPaymentForm({super.key, required this.murid});

  @override
  _AddPaymentFormState createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late int total;
  late String status;
  late String metodePembayaran;
  late String bulan;
  late DateTime tanggalPembayaran;
  late DateTime tanggalbatasbayar;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    tanggalPembayaran = DateTime.now();
    tanggalbatasbayar = DateTime.now();
  }

  Future<void> _selectDate(
      BuildContext context, bool isTanggalPembayaran) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isTanggalPembayaran ? tanggalPembayaran : tanggalbatasbayar,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null &&
        picked !=
            (isTanggalPembayaran ? tanggalPembayaran : tanggalbatasbayar)) {
      setState(() {
        if (isTanggalPembayaran) {
          tanggalPembayaran = picked;
        } else {
          tanggalbatasbayar = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Total Pembayaran'),
            keyboardType: TextInputType.number,
            onSaved: (value) {
              total = int.parse(value!);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Status'),
            onSaved: (value) {
              status = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Metode Pembayaran'),
            onSaved: (value) {
              metodePembayaran = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Bulan'),
            onSaved: (value) {
              bulan = value!;
            },
          ),
          Expanded(
            child: ListTile(
              title: Text(
                "Tanggal Pembayaran: ${DateFormat('yyyy-MM-dd').format(tanggalPembayaran)}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                "Batas Pembayaran: ${DateFormat('yyyy-MM-dd').format(tanggalbatasbayar)}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState?.save();

              if (metodePembayaran.isNotEmpty &&
                  bulan.isNotEmpty &&
                  tanggalPembayaran != null &&
                  tanggalbatasbayar != null &&
                  status.isNotEmpty &&
                  total != null) {
                Pembayaran newPembayaran = Pembayaran(
                    muridId: widget.murid.id!,
                    bulan: bulan,
                    metodePembayaran: metodePembayaran,
                    status: status,
                    tanggalPembayaran: tanggalPembayaran.toIso8601String(),
                    batasPembayaran: tanggalbatasbayar.toIso8601String(),
                    total: total);

                await _databaseHelper.insertPembayaran(newPembayaran);

                Navigator.of(context).pop();
              }
            },
            child: const Text("Tambah"),
            // onPressed: () {
            //   _formKey.currentState?.save();
            //   _addPaymentToFirestore();
            // },
            // child: const Text('Tambah Pembayaran'),
          ),
        ],
      ),
    );
  }
}

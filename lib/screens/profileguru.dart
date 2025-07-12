// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_picker/image_picker.dart';

// class Profileguru extends StatefulWidget {
//   @override
//   _ProfileguruState createState() => _ProfileguruState();
// }

// class _ProfileguruState extends State<Profileguru> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? _selectedImage;

//   Future<void> _pickImage() async {
//     // Check and request permission
//     var status = await Permission.photos.request();
//     if (status.isGranted) {
//       // Pick an image
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       setState(() {
//         _selectedImage = image;
//       });
//     } else if (status.isDenied) {
//       // Handle denied permission
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Permission denied to access photos')),
//       );
//     } else if (status.isPermanentlyDenied) {
//       // Guide user to settings
//       openAppSettings();
//     }
//   }

//   void _saveProfile() {
//     // Save profile details logic here (e.g., API call, database update)
//     print("Name: ${_nameController.text}");
//     print("Email: ${_emailController.text}");
//     if (_selectedImage != null) {
//       print("Selected Image Path: ${_selectedImage!.path}");
//     }
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Profile saved successfully!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Profile"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _selectedImage != null
//                     ? FileImage(File(_selectedImage!.path))
//                     : null,
//                 child: _selectedImage == null
//                     ? Icon(Icons.camera_alt, size: 50)
//                     : null,
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: _saveProfile,
//               child: Text("Save"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

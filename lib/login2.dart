// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:utsbimbel/home.dart';
// // import 'package:utsbimbel/authentication.dart';
// // import 'package:utsbimbel/screens/home_screen.dart';

// // import 'package:utsbimbel/signup.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   TextEditingController userText = TextEditingController();
//   TextEditingController passText = TextEditingController();

//   String? email;
//   String? password;

//   bool _obscureText = false;

//   @override
//   Widget build(BuildContext context) {
//     var _border = OutlineInputBorder(
//       borderRadius: BorderRadius.all(
//         const Radius.circular(100.0),
//       ),
//     );
//     return Scaffold(
//       body: ListView(
//         padding: const EdgeInsets.all(8.0),
//         children: <Widget>[
//           const SizedBox(height: 80),
//           Column(
//             children: [
//               Container(
//                   padding: EdgeInsets.only(left: 20, right: 20),
//                   child: Image.asset("images/Grand.jpg"),width: 300,),
//               SizedBox(height: 50),
//               Text(
//                 'Welcome !!',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 50,
//           ),
//           //===============
//         //Form(key: _formKey,
//           //child:
//           Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           //Field Username
//           TextFormField(
//             controller: userText,
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.email_outlined),
//               labelText: 'Email',
//               border: _border,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           //Field Password
//           TextFormField(
//             controller: passText,
//             obscureText: !_obscureText,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               prefixIcon: Icon(Icons.lock_outline),
//               border: _border,
//             ),
//           ),
//           SizedBox(height: 30),
//           SizedBox(
//             height: 54,
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 email = userText.text;
//                 password = passText.text;
//                 signIn(email: email!, password: password!)
//                   .then((result) {
//                     if (result == null) {
//                       Navigator.pushReplacement(context,
//                           MaterialPageRoute(builder: (context) => Home()));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: Text(
//                           result,
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ));
//                     }
//                 }) ;
//               },
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(24.0)),
//               )),
//               child: Text(
//                 'Login',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//       //),
//           //======
//           SizedBox(height: 20),
//           //Tombol Register
//           Row(
//             children: <Widget>[
//               SizedBox(width: 50),
//               Text('Have no Account? ',
//               //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               // GestureDetector(
//               //   onTap: () {
//               //     Navigator.push(context,
//               //         MaterialPageRoute(builder: (context) => Signup()));
//               //   },
//               //   child: Text('Register Now!',
//               //       style: TextStyle(fontSize: 18, color: Colors.blue)),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
    
    
    
//   }

//   Future signIn({required String email, required String password}) async {
//     try {
//       await _auth
      
//       .signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }
// }
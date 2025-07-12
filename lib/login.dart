import 'package:flutter/material.dart';
import 'package:utsbimbel/screens/homeadmin.dart';
import 'package:utsbimbel/screens/homestudent.dart';
import 'package:utsbimbel/screens/hometeacher.dart';
import 'databasehelp.dart';
import 'models/murid.dart'; // Import your Murid class
import 'models/admin.dart'; // Import your Murid class
import 'models/guru.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// Import your Murid class

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final DatabaseHelper databaseHelper = DatabaseHelper();
  // var namaMurid;
  // var alamatMurid;
  // var kelasId;
  // var tanggalLahir;
  // var username;
  // var password;
  final bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(100.0),
      ),
    );

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const SizedBox(height: 80),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                width: 300,
                child: Image.asset("assets/images/Grand.jpg"),
              ),
              const SizedBox(height: 50),
              const Text(
                'Welcome !!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'username',
                  border: border,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: !_obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: border,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await login(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  )),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Login')),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Form(
  //             child: Column(
  //               children: [
  //                 TextFormField(
  //                   controller: usernameController,
  //                   decoration: const InputDecoration(labelText: 'Username'),
  //                 ),
  //                 TextFormField(
  //                   controller: passwordController,
  //                   decoration: const InputDecoration(labelText: 'Password'),
  //                   obscureText: true,
  //                 ),
  //                 const SizedBox(height: 20),
  //                 ElevatedButton(
  //                   onPressed: () async {
  //                     await login(context);
  //                   },
  //                   child: const Text('Login'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Future<Admin?> getAdminByUsernameAndPassword(
  Future<void> login(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Validate inputs
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both username and password')),
      );
      return;
    }

    try {
      await FirebaseAnalytics.instance
          .logEvent(name: 'login_attempt', parameters: {'username': username});
      // Fetch user from database
      Murid? murid = await databaseHelper.getMuridByUsernameAndPassword(
          username, password);
      Admin? admin = await databaseHelper.getAdminByUsernameAndPassword(
          username, password);
      Guru? guru =
          await databaseHelper.getGuruByUsernameAndPassword(username, password);

      if (murid != null && murid.userType == "student") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${murid.namaMurid}!')),
        );
        await _analytics.logEvent(
          name: 'login_success',
          parameters: {'user_type': 'student'},
        );
        // var namaMurid = murid.namaMurid;
        // var muridID = murid.id;
        // var alamatMurid = murid.alamat;
        // var kelasId = murid.kelasId;
        // var tanggalLahir = murid.tanggalLahir;
        // var username = murid.username;
        // var password = murid.password;
        // var muridx = Murid(
        //     muridId: muridID,
        //     namaMurid: namaMurid,
        //     alamat: murid.alamat,
        //     kelasId: murid.kelasId,
        //     tanggalLahir: murid.tanggalLahir,
        //     username: murid.username,
        //     password: murid.password);
        // Navigate to a different screen if needed
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeMurid(
                  murid: murid)), // Replace with your home screen widget
        );
      } else if (admin != null && admin.userType == "admin") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${admin.username}!')),
        );
        await _analytics.logEvent(
          name: 'login_success',
          parameters: {'user_type': 'admin'},
        );
        // Navigate to a different screen if needed
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeAdmin(admin: admin)));
      } else if (guru != null && guru.userType == "teacher") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${guru.username}!')),
        );
        await _analytics.logEvent(
          name: 'login_success',
          parameters: {'user_type': 'teacher'},
        );
        // Navigate to a different screen if needed
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomeGuru(guru: guru)));
      } 
      else {
        await _analytics.logEvent(
          name: 'login_failed',
          parameters: {'username': username},
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      await _analytics.logEvent(
        name: 'login_error',
        parameters: {'error': e.toString()},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:utsbimbelxy/screens/home_screen.dart';
// import 'package:utsbimbelxy/screens/datamurid.dart'; // import the DataMuridScreen
// import 'package:utsbimbelxy/signup.dart';

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

//   final bool _obscureText = false;

//   @override
//   Widget build(BuildContext context) {
//     var border = const OutlineInputBorder(
//       borderRadius: BorderRadius.all(
//         Radius.circular(100.0),
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
//                   padding: const EdgeInsets.only(left: 20, right: 20), width: 300,
//                   child: Image.asset("assets/images/Grand.jpg"),),
//               const SizedBox(height: 50),
//               const Text(
//                 'Welcome !!',
//                 style: TextStyle(fontSize: 24),
//               ),
//             ],
//           ),
//           const SizedBox(height: 50),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               TextFormField(
//                 controller: userText,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   labelText: 'Email',
//                   border: border,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: passText,
//                 obscureText: !_obscureText,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock_outline),
//                   border: border,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SizedBox(
//                 height: 54,
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     email = userText.text;
//                     password = passText.text;
//                     signIn(email: email!, password: password!).then((result) {
//                       if (result == null) {
//                         // Check if the email is "admin@gmail.com"
//                         if (email == "admin@gmail.com") {
//                           // Navigate to HomeScreen for admin
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomeScreen()));
//                         } else {
//                           // Navigate to DataMuridScreen for other users
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomeScreen()));
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: Text(
//                             result,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ));
//                       }
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(24.0)),
//                     )
//                   ),
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Wrap(
//             children: <Widget>[
//               const SizedBox(width: 50),
//               const Text('Have no Account? ',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (context) => const Signup()));
//                 },
//                 child: const Text('Register Now!',
//                     style: TextStyle(fontSize: 18, color: Colors.blue)),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future signIn({required String email, required String password}) async {
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }
// }

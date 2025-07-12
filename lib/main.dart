import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'package:utsbimbel/login.dart'; // Import login2 here
import 'package:utsbimbel/databasehelp.dart'; // Import login2 here
// import 'screens/homeadmin.dart';
// import 'screens/hometeacher.dart';
// import 'screens/homestudent.dart';
// import 'login.dart';
import 'package:sqflite/sqflite.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}
void requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  requestNotificationPermissions(); 
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Received a foreground message: ${message.notification?.title}');
});
  final dbHelper = DatabaseHelper();
  await dbHelper.checkDatabaseVersion();
  await dbHelper.checkTableExistence('pembayaran');
  await dbHelper.checkTableExistence('guru');
  await dbHelper.checkTableExistence('admin');
  await dbHelper.checkTableContents();
  // await dbHelper.resetDatabase();
  runApp(const MyApp()); // Make MyApp const
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optionally remove the debug banner
      home: LoginScreen(), // Ensure Startup is const
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sams_liquor_admin/Screens/Log%20In.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: LogIn(),
  ));
}

import 'package:flutter/material.dart';
import './Screens/Admin.dart';

import './Screens/Log In.dart';
import './Screens/Splash.dart';
import './Provider/User Provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
    create: (_) => UserProvider.initialize(),
    child: MaterialApp(
      home: ScreensController(),
    ),
  ));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialised:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LogIn();
      case Status.Authenticated:
        return Admin();
      default:
        return LogIn();
    }
  }
}

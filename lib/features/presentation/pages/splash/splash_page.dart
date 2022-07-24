import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      Timer(const Duration(seconds: 3), () {
        var auth = FirebaseAuth.instance;
        if (auth.currentUser != null) {
          Navigator.pushNamedAndRemoveUntil(context, route.homePage, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, route.loginPage, (route) => false);
        }
      });
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("MyDuit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Text("Track your expense")
          ],
        ),
      ),
    );
  }
}

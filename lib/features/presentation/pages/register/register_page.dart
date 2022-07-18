import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/data/models/user_model.dart';
import 'package:myduit/features/data/repositories/authentication_repository.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  Widget _sayHello(){   //Masih ngetest buat Widget diluar build
    return Column(
      children: [
        Text(
          'Hello, this is register page',
          style: TextStyle(
              fontSize: 24,
              backgroundColor: Colors.black,
              color: Colors.white),
        ),
        ElevatedButton(
          onPressed: () {
            _toCoba(Navigator.of(context));
          },
          child: Text('Ke Coba2'))
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(  //coba-coba
    body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _sayHello(),  //manggil widgetnya
          ],
        ),
      ),
    );
  }
}

Future<void> _toCoba (NavigatorState nav) async {
  await nav.popAndPushNamed(route.cobaPage);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/data/models/user_model.dart';
import 'package:myduit/features/data/repositories/authentication_repository.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class CobaPage extends StatelessWidget{

  final String text;

  const CobaPage({required this.text});

  Widget sayText(text){ //bikin widget sayText
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BiggerText(text: sayText('Helllooo!').toString()), //manggil si sayText disini
      ),
    );
  }
}

class BiggerText extends StatefulWidget{
  final String text;

  const BiggerText({required this.text});

  @override
  State<BiggerText> createState() => _BiggerTextState(); //bisa gini
  // _BiggerTextState createState() => _BiggerTextState(); //atau begini
}

class _BiggerTextState extends State<BiggerText> {
 double _textSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.text, style: TextStyle(fontSize: _textSize)),
        ElevatedButton(
            child: Text("Perbesar"),
            onPressed: () {
              setState(() {
                _textSize = 32.0;
              });
        }),
        ElevatedButton(
            child: Text("Perkecil"),
            onPressed: () {
              setState(() {
                _textSize = 16.0;
              });
        }),
        ElevatedButton(
            child: Text("Ke Register"),
            onPressed: () {
              setState(() {
                _toRegister(Navigator.of(context));
              });
        })
      ],);
  }
}

Future<void> _toRegister (NavigatorState nav) async {
  await nav.pushNamed(route.registerPage);
}
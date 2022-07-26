import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/data/models/user_model.dart';
import 'package:myduit/features/data/repositories/authentication_repository.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late AuthenticationRepository authenticationRepository;

  @override
  void initState() {
    super.initState();

    authenticationRepository =
        AuthenticationRepository(firestore: FirebaseFirestore.instance);
  }

  bool _passwordHidden = true;

  Widget _createNameInput() {
    return TextField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(labelText: "Name"),
    );
  }

  Widget _createEmailInput() {
    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: "Email"),
    );
  }

  Widget _createPasswordInput() {
    return TextField(
      controller: _passController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      obscureText: _passwordHidden,
      decoration: InputDecoration(
          labelText: "Password",
          suffix: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              _passwordHidden
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              _passwordHidden = !_passwordHidden;
              setState(() {});
            },
          )),
    );
  }

  Widget _createRegisterButton() {
    return ElevatedButton(
        onPressed: () {
          _registerUser(Navigator.of(context), _nameController.text,
              _emailController.text, _passController.text);
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _createLoginButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(route.loginPage);
        },
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _createNameInput(),
              _createEmailInput(),
              _createPasswordInput(),
              SizedBox(height: 12,),
              Row(
                children: [
                  Expanded(child: _createRegisterButton()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _createLoginButton()),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  Future<void> _registerUser(NavigatorState nav, String name, String email, String password) async {
    var result = await FirebaseUtil.signUpEmailPassword(email, password, context);
    if (result != null) {
      var user = result.user!;
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await authenticationRepository.storeNewUserData(
          UserModel(id: user.uid, name: name, email: user.email!, timestamp: "")
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
      nav.pushNamedAndRemoveUntil(route.homePage, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
    }
  }
}
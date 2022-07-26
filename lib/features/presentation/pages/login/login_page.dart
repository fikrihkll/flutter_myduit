import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/data/models/user_model.dart';
import 'package:myduit/features/data/repositories/authentication_repository.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late AuthenticationRepository authenticationRepository;

  bool _passwordHidden = true;


  @override
  void initState() {
    super.initState();

    authenticationRepository = AuthenticationRepository(firestore: FirebaseFirestore.instance);
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          labelText: "Email"
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      obscureText: _passwordHidden,
      decoration: InputDecoration(
        labelText: "Password",
        suffix: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              _passwordHidden ?
              Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.black,
            ),
            onPressed: (){
                _passwordHidden = !_passwordHidden;
                setState(() {});
            },
        ),
      ),
    );
  }

  Widget _buildRegisterAndGoogleButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                _signInWithGoogle(Navigator.of(context));
              },
              child: const Text(
                "Login with Google",
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ),
        ),
        const SizedBox(width: 16,),
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(route.registerPage);
              },
              child: const Text(
                "Register",
                style: TextStyle(
                    color: Colors.white
                ),
              )
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  _signInWithEmail(Navigator.of(context), _emailController.text, _passController.text, context);
                },
                child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white
                    ),
                )
            ),
        )
      ],
    );
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
                _buildEmailTextField(),
                const SizedBox(
                  height: 8,
                ),
                _buildPasswordTextField(),
                const SizedBox(
                  height: 16,
                ),
                _buildLoginButton(),
                _buildRegisterAndGoogleButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(NavigatorState navigator) async {
    var result = await FirebaseUtil.signInWithGoogle();
    if (result != null && result.user != null && result.user!.email != null) {
      if (await authenticationRepository.isUserExist(result.user!.email!)) {
        navigator.pushNamedAndRemoveUntil(route.homePage, (route) => false,);
      } else {
        var user = result.user!;
        await authenticationRepository.storeNewUserData(
          UserModel(id: "", name: user.displayName!, email: user.email!, timestamp: "")
        );
        navigator.pushNamedAndRemoveUntil(route.homePage, (route) => false,);
      }
    }
  }

  Future<void> _signInWithEmail(NavigatorState nav, String email, String pass, BuildContext context) async{
    var result = await FirebaseUtil.signInWithEmail(email, pass, context);
    if (result != null && result.user != null && result.user!.email != null) {
      if(await authenticationRepository.isUserExist(result.user!.email!)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful")));
        nav.pushNamedAndRemoveUntil(route.homePage, (route) => false);
      }
    }
  }
}

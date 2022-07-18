import 'package:flutter/material.dart';
import 'package:myduit/features/presentation/pages/detail/detail_page.dart';
import 'package:myduit/features/presentation/pages/home/home_page.dart';
import 'package:myduit/features/presentation/pages/login/login_page.dart';
import 'package:myduit/features/presentation/pages/register/register_page.dart';
import 'package:myduit/features/presentation/pages/coba/coba_page.dart';

const homePage = "home_page";
const detailPage = "detail_page";
const loginPage = "login_page";
const registerPage = "register_page";
const cobaPage = "coba_page";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case detailPage:
      return MaterialPageRoute(builder: (context) => const DetailScreen());
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case registerPage:
      return MaterialPageRoute(builder: (context) => const RegisterPage());
    case cobaPage:
      return MaterialPageRoute(builder: (context) => const CobaPage(text: ''));
    default:
      throw("no such route");
  }
}

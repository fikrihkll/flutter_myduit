import 'package:flutter/material.dart';
import 'package:myduit/features/presentation/pages/detail/detail_page.dart';
import 'package:myduit/features/presentation/pages/home/home_page.dart';

const homePage = "home_page";
const detailPage = "detail_page";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case detailPage:
      return MaterialPageRoute(builder: (context) => const DetailScreen());
    default:
      throw("no such route");
  }
}

import 'package:flutter/material.dart';
import 'package:google_login/login/login_page.dart';

void main() async {
  // TODO: inicializar firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: LoginPage(),
    );
  }
}

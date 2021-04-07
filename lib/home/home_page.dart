import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/bloc/auth_bloc.dart';
import 'package:google_login/home/noticias_firebase/mis_noticias.dart';
import 'noticias_ext_api/noticias_deportes.dart';
import 'package:google_login/home/noticias_firebase/pantalla_tres.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final _pagesList = [
    NoticiasDeportes(),
    MisNoticias(),
    PantallaTres(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignOutAuthenticationEvent(),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.online_prediction),
            label: "Pantalla 1",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.open_in_browser_sharp),
            label: "Pantalla 2",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.park),
            label: "Pantalla 3",
          ),
        ],
      ),
    );
  }
}

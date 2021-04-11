import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/bloc/auth_bloc.dart';
import 'package:google_login/home/formulario/bloc/formulario_bloc.dart';
import 'package:google_login/home/noticias_ext_api/bloc/exteriornews_bloc.dart';
import 'package:google_login/home/noticias_firebase/bloc/my_news_bloc.dart';
import 'package:google_login/home/noticias_firebase/mis_noticias.dart';
import 'noticias_ext_api/noticias_deportes.dart';
import 'package:google_login/home/formulario/pantalla_tres.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final _titulosList = [
    "Deportes",
    "Mis noticias",
    "Subir noticia",
  ];
  final _pagesList = [
    NoticiasDeportes(),
    MisNoticias(),
    PantallaTres(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExteriornewsBloc()..add(RequestInitialExteriorNewsEvent()),
        ),
        BlocProvider(
          create: (context) => MyNewsBloc()..add(RequestAllNewsEvent()),
        ),
        BlocProvider(create: (context) => FormularioBloc()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_titulosList[_currentPageIndex]}"),
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
              icon: Icon(Icons.sports_kabaddi),
              label: "${_titulosList[0]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "${_titulosList[1]}",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              label: "${_titulosList[2]}",
            ),
          ],
        ),
      ),
    );
  }
}

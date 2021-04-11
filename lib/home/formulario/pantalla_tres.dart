import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/formulario/bloc/formulario_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/models/new_firebase.dart';
import '../noticias_firebase/bloc/my_news_bloc.dart';

class PantallaTres extends StatefulWidget {
  PantallaTres({Key key}) : super(key: key);

  @override
  _PantallaTresState createState() => _PantallaTresState();
}

class _PantallaTresState extends State<PantallaTres> {
  File slectedImage;
  var autorTc = TextEditingController();
  var tituloTc = TextEditingController();
  var descrTc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormularioBloc, FormularioState>(
      listener: (context, state) {
        if (state is PickedImageState) {
          slectedImage = state.image;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Imagen seleccionada"),
              ),
            );
        } else if (state is SavedNewState) {
          autorTc.clear();
          tituloTc.clear();
          descrTc.clear();
          slectedImage = null;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Noticia guardada.."),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is LoadingFormularioState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return _createForm();
      },
    );
  }

  Widget _createForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            slectedImage != null
                ? Image.file(
                    slectedImage,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: autorTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Autor',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Titulo',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descrTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripcion',
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Imagen"),
              onPressed: () {
                BlocProvider.of<FormularioBloc>(context).add(PickImageEvent());
              },
            ),
            MaterialButton(
              child: Text("Guardar"),
              onPressed: () {
                BlocProvider.of<FormularioBloc>(context).add(
                  SaveNewElementEvent(
                    noticia: NewFirebase(
                      author: autorTc.text,
                      title: tituloTc.text,
                      description: descrTc.text,
                      // publishedAt: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

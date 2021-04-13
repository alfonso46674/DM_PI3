import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/formulario/bloc/formulario_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:google_login/models/new_firebase.dart';
import 'package:share/share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class ItemNoticia extends StatefulWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  _ItemNoticiaState createState() => _ItemNoticiaState();
}

class _ItemNoticiaState extends State<ItemNoticia> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<FormularioBloc, FormularioState>(
      listener: (context, state) {
        if (state is SavedExteriorNewState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text('Noticia guardada en Firebase'),
            ));
        }
      },
// TODO: Cambiar image.network por Extended Image con place holder en caso de error o mientras descarga la imagen
      child: Container(
        height: 200,
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Builder(
                      builder:(context){
                        final condition = widget.noticia.urlToImage != null;
                        return condition
                        ? Image.network(
                      "${widget.noticia.urlToImage}",
                      height: 200,
                      fit: BoxFit.cover,
                    )
                    : 
                    Image.asset(
                      "assets/dummy-square.png",
                      height: 200,
                      fit: BoxFit.cover,
                    );
                      }
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${widget.noticia.title}",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${widget.noticia.publishedAt}",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              children: [
                                //boton para compartir
                                IconButton(
                                  icon: Icon(Icons.share_rounded),
                                  onPressed: () {
                                    _saveAndShare(widget.noticia);
                                  },
                                ),
                                //boton para subir noticia a firebase
                                IconButton(
                                  icon: Icon(Icons.upload_rounded),
                                  onPressed: () {
                                    BlocProvider.of<FormularioBloc>(context)
                                        .add(
                                      SaveExteriorElementEvent(
                                        noticia: NewFirebase(
                                            author: widget.noticia.author,
                                            title: widget.noticia.title,
                                            description: widget.noticia.description,
                                            urlToImage: widget.noticia.urlToImage),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${widget.noticia.description ?? "Descripcion no disponible"}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${widget.noticia.author ?? "Autor no disponible"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
//https://github.com/himanshusharma89/sharefiles
  Future<Null> _saveAndShare(New noticia) async {
    var response = await get(Uri.parse(noticia.urlToImage));
    final documentDirectory = (await getExternalStorageDirectory()).path;

    File imgFile = new File('$documentDirectory/noticiaImagen.png');
    imgFile.writeAsBytesSync(response.bodyBytes);

    final RenderBox box = context.findRenderObject();
    Share.shareFiles([('$documentDirectory/noticiaImagen.png')],
        subject: 'Mira esta noticia',
        text: '${noticia.title}: ${noticia.description}\n\n ${noticia.url}',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

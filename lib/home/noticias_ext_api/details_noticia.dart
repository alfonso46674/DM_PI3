import 'package:flutter/material.dart';
import 'package:google_login/models/new.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsNoticia extends StatefulWidget {
  final New noticia;
  DetailsNoticia({@required this.noticia, Key key}) : super(key: key);

  @override
  _DetailsNoticiaState createState() => _DetailsNoticiaState();
}

class _DetailsNoticiaState extends State<DetailsNoticia> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Noticia a detalle'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${widget.noticia.title}",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${widget.noticia.publishedAt}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "${widget.noticia.author ?? "Autor no disponible"}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) {
                final condition = widget.noticia.urlToImage != null;
                return condition
                    ? Container(
                        alignment: Alignment.center,
                        child: Image.network(
                          widget.noticia.urlToImage,
                          width: 400,
                          height: 300,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/dummy-square.png',
                          width: 300,
                          height: 300,
                        ),
                      );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
              child: Column(
                children: [
                  Text(
                    "${widget.noticia.description ?? "Descripcion no disponible"}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      _urlLauncher(widget.noticia.url);
                    },
                    child: Text(
                      "${widget.noticia.url}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          color: Color(0xff117fad)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

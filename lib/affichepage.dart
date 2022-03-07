import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AffichePage extends StatefulWidget {
  const AffichePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AffichePage> createState() => _AffichePageState();
}

class _AffichePageState extends State<AffichePage> {
  Map<String, dynamic> dataMap = new Map();
  bool recupDataBool = false;
  int id = 1;

  void recupData() async {
    await recupDataJson();
    if (mounted) {
      setState(() {
        recupDataJson;
      });
    }
  }

  Future<void> recupDataJson() async {
    String url = "https://pokeapi.co/api/v2/pokemon/" + this.id.toString();
    var reponse = await http.get(Uri.parse(url));
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    }
  }

  Widget afficheData() {
    Column contenu = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.empty(growable: true),
    );

    contenu.children.add(Image.network(dataMap['sprites']['front_default'].toString()));
    //contenu.children.add(Image.network(dataMap['sprites']['other']['official-artwork']['front_default'].toString()));
    contenu.children.add(Text("Name: " + dataMap['forms'][0]['name'].toString()));
    contenu.children.add(Text("Height: " + dataMap['height'].toString()));
    contenu.children.add(Text("Weight: " + dataMap['weight'].toString()));

    recupDataBool = false;

    return contenu;
  }

  Widget attente() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text('En attente des données', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        CircularProgressIndicator(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)?.settings.arguments as int;

    if (!recupDataBool) {
      recupData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: recupDataBool ? afficheData() : attente(),
      ),
    );
  }
}

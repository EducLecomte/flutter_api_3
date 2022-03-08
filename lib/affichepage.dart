import 'package:flutter/material.dart';

class AffichePage extends StatefulWidget {
  const AffichePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AffichePage> createState() => _AffichePageState();
}

class _AffichePageState extends State<AffichePage> {
  Map<String, dynamic> dataMap = new Map();

/*   void recupData() async {
    await recupDataJson();
    if (mounted) {
      setState(() {
        recupDataJson;
      });
    }
  } */

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

    return contenu;
  }

  @override
  Widget build(BuildContext context) {
    dataMap = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: afficheData(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> dataMap = new Map();
  bool recupDataBool = false;
  int id = 1;

  Future<void> recupDataJson() async {
    String url = "https://pokeapi.co/api/v2/pokemon/" + this.id.toString();
    var reponse = await http.get(Uri.parse(url));
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    } else {
      recupDataBool = false;
    }
  }

  bool isNumeric(String s) {
    bool isnum = false;
    try {
      double.parse(s);
      isnum = true;
    } catch (e) {}
    return isnum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "N° du Pokémon", hintText: "Saisir l'id d'un Pokémon"),
                //initialValue: "9782841774470",
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), LengthLimitingTextInputFormatter(3)],
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty || !isNumeric(value)) {
                    return 'N° de Pokémon non valide !';
                  } else {
                    id = int.parse(value);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      await recupDataJson();
                      if (recupDataBool) {
                        Navigator.pushNamed(context, '/affiche', arguments: dataMap);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Erreur dans recupération des informations."),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

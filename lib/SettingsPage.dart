import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'dart:html' as html;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

@JS()
external void closeBrowser();

class SettingsDialog extends StatelessWidget {
  final SharedPreferences _prefs;

  SettingsDialog(this._prefs);



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300.0,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Divider(color: Colors.grey),
            ElevatedButton.icon(
              onPressed: () {
                showFavorisDialog(context, _prefs);
              },
              icon: Icon(Icons.favorite),
              label: Text('Favoris'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                html.window.close();
                print('Déconnexion');
              },
              icon: Icon(Icons.logout),
              label: Text('Déconnexion'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                print('Autre option');
              },
              icon: Icon(Icons.settings),
              label: Text('Autre option'),
            ),
          ],
        ),
      ),
    );
  }

  void showFavorisDialog(BuildContext context, SharedPreferences prefs) {
    List<String> entreprises = [
      "Accor",
      "Air Liquide",
      "AIRBUS",
      "ArecorMittal",
      "AXA",
      "BNP Paribas",
      "Bouygues",
      "Capgemini",
      "Carrefour",
      "CREDIT AGRICOLE", //?
      "Danone",
      "DASSAULT SYSTEMES",//?
      "EDENRED",//?
      "Engie",
      "Essilor",
      "EUROFINS SCIENTIFIC",//?
      "HERMES INTERNATIONAL",//?
      "Kering",
      "Legrand",
      "L'OREAL",//?
      "LVMH",
      "Michelin",
      "Orange",
      "Pernod Ricard",
      "Publicis",
      "Renault",
      "Saint-Gobain",
      "Sanofi",
      "Schneider Electric",
      "SOCIETE GENERALE",//comme d'assault
      "STELLANTIS",
      "STMicroelectronics",
      "TELEPERFORMANCE",
      "Thales Group",
      "Total",
      "Unibail-Rodamco-Westfield",
      "Veolia",
      "Vinci",
      "Vivendi",
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FavorisDialog(entreprises: entreprises, prefs: prefs);
      },
    );
  }
}

class FavorisDialog extends StatefulWidget {
  final List<String> entreprises;
  final SharedPreferences prefs;

  FavorisDialog({required this.entreprises, required this.prefs});

  @override
  _FavorisDialogState createState() => _FavorisDialogState();
}

class _FavorisDialogState extends State<FavorisDialog> {
  final List<String> favoris = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    List<String>? savedFavorites = widget.prefs.getStringList('favoris');
    if (savedFavorites != null) {
      setState(() {
        favoris.addAll(savedFavorites);
      });
    }
  }

  Future<void> fetchPrediction(String companyName) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'entreprise_name': companyName}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0.5),
            child: Container(
              width: 300.0,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    companyName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Text(
                    'High Prediction: ${data['high_prediction']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Low Prediction: ${data['low_prediction']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fermer'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text('Erreur lors de la récupération des prédictions'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300.0,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sélectionnez vos favoris',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.grey),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.entreprises.length,
                itemBuilder: (context, index) {
                  final entreprise = widget.entreprises[index];
                  return CheckboxListTile(
                    title: Text(entreprise),
                    value: favoris.contains(entreprise),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          favoris.add(entreprise);
                        } else {
                          favoris.remove(entreprise);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('favoris', favoris);
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavorisItem extends StatelessWidget {
  final String entreprise;

  FavorisItem({required this.entreprise});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0,
              backgroundColor: Colors.black.withOpacity(0.5),
              child: Container(
                width: 300.0,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entreprise,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(color: Colors.grey),
                    FutureBuilder<http.Response>(
                      future: http.post(
                        Uri.parse('http://127.0.0.1:5000/predict'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({'entreprise_name': entreprise}),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Erreur: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          var data = jsonDecode(snapshot.data!.body);
                          return Column(
                            children: [
                              Text(
                                'High Prediction: ${data['high_prediction']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Low Prediction: ${data['low_prediction']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        } else {
                          return Text('Erreur lors de la récupération des prédictions');
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Fermer'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          entreprise,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

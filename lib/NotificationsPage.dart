import 'package:flutter/material.dart';

class NotificationsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Liste des nouvelles sur les entreprises du CAC40
    List<String> news = [
      "Nouvelle 1 sur l'entreprise A",
      "Nouvelle 2 sur l'entreprise B",
      "Nouvelle 3 sur l'entreprise C",
      "Nouvelle 4 sur l'entreprise D",
      "Nouvelle 5 sur l'entreprise E",
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
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
              // Barre de titre de la boîte de dialogue
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Bouton de fermeture de la boîte de dialogue
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Divider(color: Colors.black),
              SizedBox(height: 10),
              Text(
                'News sur les entreprises du CAC40',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Afficher les nouvelles dans des carrés plus petits
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: news.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Augmenter le nombre de colonnes
                  childAspectRatio: 1, // Ratio d'aspect 1:1 pour les carrés
                  mainAxisSpacing: 10, // Espacement vertical
                  crossAxisSpacing: 10, // Espacement horizontal
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200], // Couleur de fond
                    ),
                    child: Center(
                      child: Text(
                        news[index],
                        textAlign: TextAlign.center, // Centrer le texte
                        style: TextStyle(
                          fontSize: 14, // Taille de police réduite
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

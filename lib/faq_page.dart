import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQ ubercheat',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.black, 
      ),
      backgroundColor: Colors.black, 
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            backgroundColor: Colors.green[900], 
            title: Text(
              "Comment commander sur l'application ?",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Sélectionnez d'abord votre restaurant ou plat préféré, ajoutez vos choix à votre panier, puis suivez les instructions pour compléter votre commande. Vous pourrez revoir votre commande avant de la confirmer définitivement.",
                  style: TextStyle(color: Colors.green[100]), 
                ),
              ),
            ],
          ),
          
          ExpansionTile(
            backgroundColor: Colors.green[900], 
            title: Text(
              "Puis-je suivre ma commande en temps réel ?",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Oui, après avoir passé votre commande, un suivi en temps réel sera disponible dans l'application, vous permettant de voir l'état de votre commande et le temps estimé de livraison.",
                  style: TextStyle(color: Colors.green[100]),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}

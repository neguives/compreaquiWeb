import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardProdutosComprados extends StatelessWidget {
  QuerySnapshot snapshot;

  String nomeEmpresa;
  CardProdutosComprados(this.nomeEmpresa);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Vizualizar Produtos",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[],
      ),
    );
  }
}

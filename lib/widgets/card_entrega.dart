import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardEntrega extends StatelessWidget {
  String nomeEmpresa;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Cupom de desconto",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                MaterialButton(
                  child: Text("Entrega Expressa  --------   R\$ 6,90"),
                  onPressed: (){
                    CartModel.of(context)
                        .setCupon("text", 50);
                  },

                ),
                MaterialButton(
                  child: Text("Entrega Expressa  --------   R\$ 6,90"),
                  onPressed: (){
                    CartModel.of(context)
                        .setCupon("text", 50);
                  },

                )
              ],
            )
            ,
          ),

        ],
      ),
    );
  }
}

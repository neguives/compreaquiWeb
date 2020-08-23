import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/cart_screen.dart';
import 'package:compreaidelivery/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// ignore: must_be_immutable
class CartButton extends StatelessWidget {
  ProductData product;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  CartButton(
      {this.product,
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Stack(children: <Widget>[
        Icon(
          Icons.shopping_cart,
          color: Colors.deepPurple,
          size: 35,
        ),
        ScopedModelDescendant<CartModel>(
            builder: (BuildContext context, Widget child, CartModel cartModel) {
          if (cartModel.products.length != null &&
              cartModel.products.length > 0) {
            return Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  //color: Colors.redAccent,
                  child: Text('${cartModel.products.length}',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ));
          } else
            return Container(
              height: 1,
              width: 1,
            );
        }),
      ]),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartScreen(
                product,
                nomeEmpresa,
                imagemEmpresa,
                cidadeEstado,
                endereco,
                latitude,
                longitude,
                telefone)));
      },
      backgroundColor: Colors.white70,
    );
  }
}

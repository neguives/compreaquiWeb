import 'package:compreaidelivery/datas/product_data.dart';
import 'package:compreaidelivery/ecoomerce/cart_screen.dart';
import 'package:compreaidelivery/ecoomerce/produtosTwo.dart';
import 'package:compreaidelivery/widgets/AnimatedBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class BottomPrincipal extends StatefulWidget {
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  BottomPrincipal(this.nomeEmpresa, this.imagemEmpresa, this.cidadeEstado,
      this.endereco, this.latitude, this.longitude, this.telefone);
  final List<BarItem> barItems = [
    BarItem(
      text: "Meu carrinho",
      iconData: Icons.shopping_cart,
      color: Colors.blueAccent.shade700,
    ),
    BarItem(
      text: "Produtos e Serviços",
      iconData: Icons.add_circle_outline,
      color: Colors.blueAccent.shade700,
    ),

    /*BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    */
  ];
  @override
  _BottomPrincipal createState() => _BottomPrincipal(
      this.nomeEmpresa,
      this.imagemEmpresa,
      this.cidadeEstado,
      this.endereco,
      this.latitude,
      this.longitude,
      this.telefone);
}

class _BottomPrincipal extends State<BottomPrincipal> {
  ProductData productData;

  int selectedBarIndex = 1;
  String nomeEmpresa, imagemEmpresa, cidadeEstado, endereco, telefone;
  double latitude, longitude;
  _BottomPrincipal(this.nomeEmpresa, this.imagemEmpresa, this.cidadeEstado,
      this.endereco, this.latitude, this.longitude, this.telefone);
  @override
  Widget build(BuildContext context) {
    print(nomeEmpresa);
    double width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //systemNavigationBarColor: Colors.lightBlue[700], // navigation bar color
        //statusBarColor: Colors.lightBlue[700],
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.deepPurpleAccent,
        statusBarIconBrightness: Brightness.dark // status bar color
        ));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    List<Widget> telas = [
      CartScreen(productData, nomeEmpresa, imagemEmpresa, cidadeEstado,
          endereco, latitude, longitude, telefone),
      SelecaoCategoria(nomeEmpresa, imagemEmpresa, cidadeEstado, endereco,
          latitude, longitude, telefone),
//      OrdersTab(nomeEmpresa, imagemEmpresa, cidadeEstado),
    ];
    return Scaffold(
      body: telas[selectedBarIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 500),
        barStyle: BarStyle(fontSize: width * 0.024, iconSize: width * 0.07),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}

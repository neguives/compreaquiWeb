import 'package:compreaidelivery/ecoomerce/produtosTwo.dart';
import 'package:compreaidelivery/widgets/AnimatedBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomPrincipal extends StatefulWidget {
  String nomeEmpresa, imagemEmpresa;
  BottomPrincipal(
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
  );
  final List<BarItem> barItems = [
    BarItem(
      text: "Conversar",
      iconData: Icons.chat,
      color: Colors.purple,
    ),
    BarItem(
      text: "Produtos",
      iconData: Icons.add_circle_outline,
      color: Colors.blueAccent.shade700,
    ),
    BarItem(
      text: "Meu carrinho",
      iconData: Icons.shopping_cart,
      color: Colors.blueAccent.shade700,
    ),
    BarItem(
      text: "Minhas Solicitações",
      iconData: Icons.check,
      color: Colors.lightBlue.shade900,
    ),

    /*BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    */
  ];
  @override
  _BottomPrincipal createState() =>
      _BottomPrincipal(this.nomeEmpresa, this.imagemEmpresa);
}

class _BottomPrincipal extends State<BottomPrincipal> {
  int selectedBarIndex = 1;
  String nomeEmpresa, imagemEmpresa;

  _BottomPrincipal(
    @required this.nomeEmpresa,
    @required this.imagemEmpresa,
  );
  @override
  Widget build(BuildContext context) {
    print(nomeEmpresa);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
      SelecaoCategoria(nomeEmpresa, imagemEmpresa),
      SelecaoCategoria(nomeEmpresa, imagemEmpresa),
      SelecaoCategoria(nomeEmpresa, imagemEmpresa),
      SelecaoCategoria(nomeEmpresa, imagemEmpresa),
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

import 'package:compreaidelivery/ecoomerce/checkout_screen.dart';
import 'package:compreaidelivery/telas/Login.dart';
import 'package:compreaidelivery/telas/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mysql1/mysql1.dart';
import 'package:scoped_model/scoped_model.dart';

import 'ecoomerce/formaPagamento.dart';
import 'models/cart_model.dart';
import 'models/user_model.dart';

main() {
  // Finally, close the connection
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              routes: <String, WidgetBuilder>{
                '/login': (BuildContext context) => new Login(),
              },
              home: SplashScreen(),
//      home: Principal(),
              debugShowCheckedModeBanner: false,
              title: "CompreAqui Delivery",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 20, 125, 141)),
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/finalizarPagamento':
                    return MaterialPageRoute(builder: (_) => CheckoutScreen());

                  default:
                    return MaterialPageRoute(
                        builder: (_) => Login(), settings: settings);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:compreaidelivery/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class FreteModel extends Model {
  //Cupom de desconto
  double precoFreteKarona = 0;
  UserModel user;

  static FreteModel of(BuildContext context) =>
      ScopedModel.of<FreteModel>(context);

  void setFreteKarona(double precoFrete) {
    this.precoFreteKarona = precoFrete;
  }

  double getFreteKarona() {
    return precoFreteKarona;
  }
}

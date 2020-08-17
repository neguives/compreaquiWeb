import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/datas/user_final_data.dart';
import 'package:compreaidelivery/ecoomerce/services/cielo_payment.dart';
import 'package:compreaidelivery/models/credit_card.dart';
import 'package:flutter/cupertino.dart';

class CheckoutManager extends ChangeNotifier {
  UserFinalData user;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final CieloPayment cieloPayment = CieloPayment();

  final Firestore firestore = Firestore.instance;

  // ignore: use_setters_to_change_properties

  Future<void> checkout(
      {CreditCard creditCard,
      Function onStockFail,
      Function onSuccess,
      Function onPayFail}) async {
    loading = true;

    final orderId = await _getOrderId();

    String payId;
    try {
      payId = await cieloPayment.authorize(
        creditCard: creditCard,
        price: 123,
        orderId: orderId.toString(),
        user: user,
      );
      debugPrint('success $payId');
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    try {} catch (e) {
      cieloPayment.cancel(payId);
      onStockFail(e);
      loading = false;
      return;
    }

    try {
      await cieloPayment.capture(payId);
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    loading = false;
  }

  Future<int> _getOrderId() async {
    final ref = firestore.document('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc.data['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      });
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }
}

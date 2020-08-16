import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:compreaidelivery/datas/user_final_data.dart';
import 'package:flutter/cupertino.dart';

class CieloPayment {
  final CloudFunctions functions = CloudFunctions.instance;

  Future<String> authorize(
      {num price, String orderId, UserFinalData user}) async {
    Map<String, dynamic> toJson() {
      return {
        'cardNumber': "11111111111111",
        'holder': "LUCAS SANTOS REINALDO",
        'expirationDate': "22/2024",
        'securityCode': "333",
        'brand': "VISA",
      };
    }

    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        //'amount': 10 * 100,
        'softDescriptor': 'App CompreAqui',
        'installments': 1,
        'creditCard': toJson(),
        'cpf': user.email,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable =
          functions.getHttpsCallable(functionName: 'authorizeCreditCard');
      callable.timeout = const Duration(seconds: 60);
      final response = await callable.call(dataSale);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {'payId': payId};
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'captureCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Captura realizada com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {'payId': payId};
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'cancelCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }
}

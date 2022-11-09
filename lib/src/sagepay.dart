import 'package:flutter/material.dart';
import 'package:sagepay/src/payment_response.dart';
import 'package:sagepay/src/sagepay_checkout.dart';
import 'package:sagepay/src/utils/business.dart';

class SagePay {
  final BuildContext context;
  final Business business;
  final String reference;
  final String callbackUrl;
  final double amount;
  final String token;
  final Map<String, dynamic>? metadata;

  SagePay({
    required this.context,
    required this.business,
    required this.reference,
    required this.callbackUrl,
    required this.amount,
    required this.token,
    this.metadata
  });

  Future<PaymentResponse?> chargeTransaction() async {
    final request = SagePay(
      context: context,
      business: business,
      reference: reference,
      callbackUrl: callbackUrl,
      amount: amount,
      token: token,
      metadata: metadata
    );
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SagePayCheckout(
          request: request,
          mainContext: context,
        ),
      ),
    );
  }
}

import 'package:sagepay/src/transaction_status.dart';

class PaymentResponse {
  String? status;
  bool? success;
  String? transactionId;
  String? txRef;

  PaymentResponse({this.status, this.success, this.transactionId, this.txRef});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? TransactionStatus.ERROR;
    success = json['success'] ?? false;
    transactionId = json['transaction_id'];
    txRef = json['tx_ref'];
  }

  /// Converts this instance to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['transaction_id'] = transactionId;
    data['tx_ref'] = txRef;
    return data;
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sagepay/src/payment_response.dart';
import 'package:sagepay/src/sagepay.dart';
import 'package:sagepay/src/services/service.dart';
import 'package:sagepay/src/transaction_callback.dart';
import 'package:sagepay/src/utils/sage_pay_utils.dart';

class SagePayCheckout extends StatefulWidget {
  final BuildContext mainContext;
  final SagePay request;

  const SagePayCheckout({Key? key, required this.mainContext, required this.request}) : super(key: key);

  @override
  State<SagePayCheckout> createState() => _SagePayCheckoutState();
}

class _SagePayCheckoutState extends State<SagePayCheckout> implements TransactionCallBack {
  final _navigatorKey = GlobalKey<NavigatorState>();

  Timer? timer;
  bool startTimer = false;

  String? url;
  bool loading = false;
  String? error;

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (startTimer) {
        await APIServices().paymentStatus(widget.request.token, widget.request.reference).then((value) {
          if (value['data'].isNotEmpty) {
            print(value);
            if (value['data']['transaction_data']['status'] == "SUCCESSFUL") {
              timer!.cancel();
              Navigator.pop(widget.mainContext, PaymentResponse(status: "success", success: true));
              print("Payment was successful");
            } else if (value['data']['transaction_data']['status'] == "FAILED") {
              timer!.cancel();
              Navigator.pop(widget.mainContext, PaymentResponse(status: "failed", success: false));
              print("Payment was unsuccessful");
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _navigatorKey,
      theme: ThemeData(textTheme: GoogleFonts.quicksandTextTheme()),
      home: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: !startTimer
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/bg_img.png', package: 'sagepay'),
                      fit: BoxFit.cover,
                    )),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 20,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: error != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(error!),
                                          )
                                        : const SizedBox(),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        var data = {
                                          "email": widget.request.business.email,
                                          "amount": widget.request.amount,
                                          "reference": widget.request.reference,
                                          "phone": "09098877876",
                                          "callback_url": widget.request.callbackUrl,
                                          "metadata": widget.request.metadata
                                        };
                                        error = null;
                                        loading = true;
                                        setState(() {});
                                        APIServices().initializeCheckout(data, widget.request.token).then((value) {
                                          if (value != null && value['success']) {
                                            url = value['data']['payment_url'];
                                            startTimer = true;
                                            // InAppBrowser().openUrlRequest(
                                            //   urlRequest: URLRequest(
                                            //     url: Uri.parse(value['data']['payment_url']),
                                            //   ),
                                            //   options: InAppBrowserClassOptions(
                                            //     crossPlatform: InAppBrowserOptions(
                                            //       hideProgressBar: true,
                                            //       hideUrlBar: true,
                                            //       hideToolbarTop: true
                                            //     ),
                                            //   ),
                                            // );
                                            loading = false;
                                            error = null;
                                            setState(() {});
                                          } else {
                                            loading = false;
                                            error = value!['message'];
                                            setState(() {});
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: SagePayUtils.orangePrimary,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                          padding: const EdgeInsets.all(20)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('Make Payment'),
                                          loading
                                              ? const Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: CircularProgressIndicator(color: Colors.white),
                                                  ),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(widget.mainContext),
                              child: Text("Cancel", style: TextStyle(color: SagePayUtils.orangePrimary)),
                            ),
                          ),
                        ),
                      ],
                    ))
                : Column(
                    children: [
                      Expanded(
                        child: InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(
                            url: Uri.parse(url!),
                          ),
                          initialOptions: InAppWebViewGroupOptions(
                            android: AndroidInAppWebViewOptions(
                              useHybridComposition: true,
                            ),
                          ),
                          onWebViewCreated: (InAppWebViewController controller) {
                            webViewController = controller;
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  onTransactionError() {
    _showErrorAndClose("Transaction error");
  }

  @override
  onCancelled() {
    // Fluttertoast.showToast(msg: "Transaction Cancelled");
    Navigator.pop(widget.mainContext);
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    final PaymentResponse chargeResponse = PaymentResponse(status: "success", success: true, transactionId: id, txRef: txRef);
    Navigator.pop(widget.mainContext, chargeResponse);
  }

  void _showErrorAndClose(final String errorMessage) {
    // Fluttertoast.showToast(msg: errorMessage);
    Navigator.pop(widget.mainContext); // return response to user
  }
}

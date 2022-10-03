import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sagepay/src/payment_response.dart';
import 'package:sagepay/src/utils/sage_pay_utils.dart';

class CardPayment extends StatefulWidget {
  final BuildContext mainContext;

  const CardPayment({Key? key, required this.mainContext}) : super(key: key);

  @override
  State<CardPayment> createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCirc,
      child: Column(
        children: [
          CardTextViews(formKey: formKey),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(widget.mainContext, PaymentResponse(status: "failed", success: false));
                    },
                    child: Text("Cancel", style: TextStyle(color: SagePayUtils.orangePrimary)),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // var payload = {
                          //   "card_number": _cardNumber.toString(),
                          //   "exp_month": _expDate!.substring(0, 2),
                          //   "exp_year": _expDate!.substring(_expDate!.length - 2, _expDate!.length),
                          //   "cvv": _cvv.toString(),
                          //   // "pin": cardpin.toString(),
                          //   // "access_code": accesscode,
                          // };
                          Navigator.pop(widget.mainContext, PaymentResponse(status: "success", success: true));
                          //print(Teqrypt().encrypt(jsonEncode(payload)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: SagePayUtils.orangePrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(20)),
                      child: const Text("Enter PIN"),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TransferPayment extends StatefulWidget {
  final BuildContext mainContext;
  const TransferPayment({Key? key, required this.mainContext}) : super(key: key);

  @override
  State<TransferPayment> createState() => _TransferPaymentState();
}

class _TransferPaymentState extends State<TransferPayment> {
  bool isAccountRequest = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !isAccountRequest
              ? Column(children: [
                  Image.asset("assets/images/man-sitting.jpeg", height: 160, package: 'sagepay'),
                  const SizedBox(height: 10),
                  const Text(
                    "Please request an account to initiate payment with transfer",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ])
              : Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/bank.svg", package: 'sagepay'),
                        const SizedBox(width: 10),
                        const Text("Wema Bank - SAGECLOUD-Intellects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("0990099890", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.copy,
                            color: SagePayUtils.orangePrimary,
                            size: 28,
                          ),
                        )
                      ],
                    )
                  ],
                ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(widget.mainContext, PaymentResponse(status: "failed", success: false));
                    },
                    child: Text("Cancel", style: TextStyle(color: SagePayUtils.orangePrimary)),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!isAccountRequest) {
                          isAccountRequest = true;
                          setState(() {});
                        } else {
                          Navigator.pop(widget.mainContext, PaymentResponse(status: "success", success: true));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: SagePayUtils.orangePrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(20)),
                      child: Text(isAccountRequest ? "Enter PIN" : "Request Account"),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

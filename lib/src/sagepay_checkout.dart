import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sagepay/src/payment_response.dart';
import 'package:sagepay/src/sagepay.dart';
import 'package:sagepay/src/transaction_cellback.dart';
import 'package:sagepay/src/utils/payment_tabs.dart';
import 'package:sagepay/src/utils/sage_pay_utils.dart';

class SagePayCheckout extends StatefulWidget {
  final BuildContext mainContext;
  final SagePay request;

  const SagePayCheckout({Key? key, required this.mainContext, required this.request}) : super(key: key);

  @override
  State<SagePayCheckout> createState() => _SagePayCheckoutState();
}

class _SagePayCheckoutState extends State<SagePayCheckout> implements TransactionCallBack {
  late PageController _pageController;
  int _selectedPage = 0;

  final _navigatorKey = GlobalKey<NavigatorState>();
  List<String> errors = [];

  static String formatAmount(amount) {
    return NumberFormat('#,###,###,###.##').format(amount);
  }

  Map<String, dynamic> data = {};

  @override
  void initState() {
    _pageController = PageController();
    data = {
      "email": widget.request.business.email,
      "amount": widget.request.amount,
      "reference": widget.request.reference,
      "callback_url": widget.request.callbackUrl
    };
    super.initState();
  }

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme()
      ),
      home: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/bg_img.png', package: 'sagepay'), fit: BoxFit.cover),
              ),
              // color: Colors.white,
              child: FutureBuilder<dynamic>(
                  // future: _memoizer.runOnce(() async {
                  //   return await FirebaseFirestore.instance.collection('Collector').doc(FirebaseAuth.instance.currentUser!.uid.toString()).get();
                  // }),
                  // future: _memoizer.runOnce(() async {
                  //   return await APIServices().initializeCheckout({
                  //     "email": widget.business.email,
                  //     "amount": widget.amount,
                  //     "reference": widget.reference,
                  //     "phone": "09098877876",
                  //     "callback_url": widget.callbackUrl
                  //   }, widget.token);
                  // }),
                  future: null,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    // if (snapshot.connectionState == ConnectionState.done) {
                    //   if (snapshot.data != null && snapshot.data!['success']) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: .6)),
                                child: widget.request.business.imageUrl == null
                                    ? Image.asset('assets/images/capital_sage.png', package: 'sagepay',)
                                    : Image.asset(widget.request.business.imageUrl!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.request.business.name, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text(widget.request.business.email,
                                      style:
                                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 25),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: SagePayUtils.bgGrey,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TabButton(
                                    selectedPage: _selectedPage,
                                    pageNumber: 0,
                                    svgPath: "assets/icons/card.svg",
                                    text: "Card",
                                    onPressed: () {
                                      _changePage(0);
                                    }),
                                TabButton(
                                    selectedPage: _selectedPage,
                                    pageNumber: 1,
                                    svgPath: "assets/icons/bank.svg",
                                    text: "Transfer",
                                    onPressed: () {
                                      _changePage(1);
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You will be charged",
                                    style: TextStyle(color: SagePayUtils.hexToColor("#A49890"), fontSize: 16),

                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "₦${formatAmount(widget.request.amount)}",
                                    style:
                                        const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: _changePage,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [CardPayment(mainContext: widget.mainContext), TransferPayment(mainContext: widget.mainContext)],
                            ),
                          ),
                        ],
                      ),
                    );
                    // } else {
                    //   return Center(
                    //     child: Text("snapshot.data!['message']"),
                    //   );
                    // }
                    // } else {
                    //   return const Center(child: CircularProgressIndicator());
                    // }
                  }),
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
    Fluttertoast.showToast(msg: "Transaction Cancelled");
    Navigator.pop(widget.mainContext);
  }

  @override
  onTransactionSuccess(String id, String txRef) {
    final PaymentResponse chargeResponse = PaymentResponse(status: "success", success: true, transactionId: id, txRef: txRef);
    Navigator.pop(widget.mainContext, chargeResponse);
  }

  void _showErrorAndClose(final String errorMessage) {
    Fluttertoast.showToast(msg: errorMessage);
    Navigator.pop(widget.mainContext); // return response to user
  }
}

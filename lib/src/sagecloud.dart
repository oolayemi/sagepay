import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SagePayCheckout extends StatefulWidget {
  final Business business;
  final String reference;
  final String callbackUrl;
  final double amount;
  final String token;

  const SagePayCheckout(
      {Key? key,
        required this.business,
        required this.amount,
        required this.reference,
        required this.callbackUrl,
        required this.token})
      : super(key: key);

  @override
  State<SagePayCheckout> createState() => _SagePayCheckoutState();
}

class _SagePayCheckoutState extends State<SagePayCheckout> {
  late PageController _pageController;
  int _selectedPage = 0;

  final _formKey = GlobalKey<FormState>();


  CreditCardType? type;

  List<String> errors = [];

  static Color orangePrimary = hexToColor('#FF6600');
  static Color lightGrey = hexToColor('#8E8E93');
  static Color bgGrey = hexToColor('#F0EDEC');

  static String formatAmount(amount) {
    return NumberFormat('#,###,###,###.##').format(amount);
  }

  Map<String, dynamic> data = {};

  @override
  void initState() {
    _pageController = PageController();
    data = {
      "email": widget.business.email,
      "amount": widget.amount,
      "reference": widget.reference,
      "callback_url": widget.callbackUrl
    };
    super.initState();
  }

  void _changePage(int pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/bg_img.png'), fit: BoxFit.cover),
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
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey, width: .6)),
                              child: widget.business.imageUrl == null
                                  ? Image.asset('assets/images/capital_sage.png')
                                  : Image.network(widget.business.imageUrl!),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.business.name, style: GoogleFonts.quicksand(textStyle: const TextStyle(fontSize: 16))),
                                const SizedBox(height: 5),
                                Text(widget.business.email,
                                    style: GoogleFonts.quicksand(
                                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
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
                            color: bgGrey,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              tabButton(
                                  selectedPage: _selectedPage,
                                  pageNumber: 0,
                                  svgPath: "assets/icons/card.svg",
                                  text: "Card",
                                  onPressed: () {
                                    _changePage(0);
                                  }),
                              tabButton(
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
                                  "₦${formatAmount(widget.amount)}",
                                  style:
                                  GoogleFonts.quicksand(textStyle: const TextStyle(fontSize: 45, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "You will be charged:",
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(color: hexToColor("#A49890"), fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: _changePage,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [cardPayment(), transferPayment()],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget cardPayment() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCirc,
      child: Column(
        children: [
          cardTextViews(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("Cancel", style: TextStyle(color: orangePrimary)),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context, true);
                          //print(Teqrypt().encrypt(jsonEncode(payload)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: orangePrimary,
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

  Widget transferPayment() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: orangePrimary,
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

  Widget cardTextViews() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              color: hexToColor('#DEDBDA').withOpacity(.28),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Card number', style: GoogleFonts.josefinSans(textStyle: const TextStyle(fontSize: 18))),
                    getCardTypeIcon(type) != null ? SvgPicture.asset(getCardTypeIcon(type)!, width: 25, height: 15) : const SizedBox()
                  ],
                ),
                TextFormField(
                  inputFormatters: [
                    MaskedInputFormatter(
                      "#### #### #### ####",
                      allowedCharMatcher: RegExp(r'\d+'),
                    ),
                  ],
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: null,
                    border: InputBorder.none,
                    hintText: "0000 0000 0000 0000",
                    hintStyle: GoogleFonts.josefinSans(
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  onChanged: (value) {
                    type = detectCCType(value);
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Card number field cannot be empty";
                    } else if (value.replaceAll(' ', '').length < 16) {
                      return "Incomplete card number";
                    } else {
                      return null;
                    }
                  },
                  style: GoogleFonts.josefinSans(
                    textStyle: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15)),
                    color: hexToColor('#DEDBDA').withOpacity(.28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valid through', style: GoogleFonts.josefinSans(textStyle: const TextStyle(fontSize: 18))),
                      TextFormField(
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "MM / YY",
                          hintStyle: GoogleFonts.josefinSans(
                            textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                          ),
                        ),
                        style: GoogleFonts.josefinSans(
                          textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 6.0, fontWeight: FontWeight.w600),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          } else if (value.replaceAll(' ', '').length < 5) {
                            return "Incomplete exp date";
                          } else {
                            return null;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15)),
                    color: hexToColor('#DEDBDA').withOpacity(.28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: GoogleFonts.josefinSans(textStyle: const TextStyle(fontSize: 18))),
                      TextFormField(
                        inputFormatters: [CreditCardCvcInputFormatter()],
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: "0000 0000 0000 0000",
                          hintStyle: GoogleFonts.josefinSans(
                            textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        style: GoogleFonts.josefinSans(
                          textStyle:
                          const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          } else if (value.replaceAll(' ', '').length < 3) {
                            return "Incomplete cvv number";
                          } else {
                            return null;
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? getCardTypeIcon(CreditCardType? type) {
    switch (type) {
      case CreditCardType.visa:
        return "assets/logos/visa.svg";
      case CreditCardType.mastercard:
        return "assets/logos/mastercard.svg";
      case CreditCardType.unknown:
        return null;
      default:
        return null;
    }
  }

  tabButton({dynamic onPressed, required int selectedPage, required int pageNumber, required String svgPath, required String text}) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 3000,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: const EdgeInsets.all(12),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.43,
        decoration: BoxDecoration(
          color: selectedPage == pageNumber ? orangePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgPath,
                color: selectedPage == pageNumber ? Colors.white : lightGrey,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                TextStyle(color: selectedPage == pageNumber ? Colors.white : lightGrey, fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Business {
  final String? imageUrl;
  final String name;
  final String email;

  Business({required this.name, required this.email, this.imageUrl});
}

import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_cvc_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/credit_card_expiration_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';

class SagePayUtils {
  static Color orangePrimary = hexToColor('#FF6600');
  static Color lightGrey = hexToColor('#8E8E93');
  static Color bgGrey = hexToColor('#F0EDEC');

  static String? getCardTypeIcon(CreditCardType? type) {
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

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}

class TabButton extends StatefulWidget {
  final dynamic onPressed;
  final int selectedPage;
  final int pageNumber;
  final String svgPath;
  final String text;

  const TabButton(
      {Key? key, this.onPressed, required this.selectedPage, required this.pageNumber, required this.svgPath, required this.text})
      : super(key: key);

  @override
  State<TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<TabButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 1000,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: const EdgeInsets.all(12),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.43,
        decoration: BoxDecoration(
          color: widget.selectedPage == widget.pageNumber ? SagePayUtils.orangePrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.svgPath,
                package: 'sagepay',
                color: widget.selectedPage == widget.pageNumber ? Colors.white : SagePayUtils.lightGrey,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: widget.selectedPage == widget.pageNumber ? Colors.white : SagePayUtils.lightGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardTextViews extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const CardTextViews({Key? key, required this.formKey}) : super(key: key);

  @override
  State<CardTextViews> createState() => _CardTextViewsState();
}

class _CardTextViewsState extends State<CardTextViews> {
  CreditCardType? type;

  ValueNotifier<String?> cardNumber = ValueNotifier<String?>(null);
  ValueNotifier<String?> expDate = ValueNotifier<String?>(null);
  ValueNotifier<String?> cvvNumber = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              color: SagePayUtils.hexToColor('#DEDBDA').withOpacity(.28),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Card number', style: const TextStyle(fontSize: 18)),
                    SagePayUtils.getCardTypeIcon(type) != null
                        ? SvgPicture.asset(SagePayUtils.getCardTypeIcon(type)!, width: 25, height: 15, package: 'sagepay',)
                        : const SizedBox()
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
                    hintStyle: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                  ),
                  onChanged: (value) {
                    cardNumber.value = value.replaceAll(' ', '');
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
                  style: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
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
                    color: SagePayUtils.hexToColor('#DEDBDA').withOpacity(.28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valid through', style: const TextStyle(fontSize: 18)),
                      TextFormField(
                        inputFormatters: [CreditCardExpirationDateFormatter()],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "MM / YY",
                          hintStyle:
                              const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                        ),
                        style: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 6.0, fontWeight: FontWeight.w600),
                        onChanged: (value) {
                          expDate.value = value.replaceAll(' ', '');
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
                    color: SagePayUtils.hexToColor('#DEDBDA').withOpacity(.28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CVV', style: const TextStyle(fontSize: 18)),
                      TextFormField(
                        inputFormatters: [CreditCardCvcInputFormatter()],
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          // hintText: "0000 0000 0000 0000",
                          hintStyle:
                              const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                        ),
                        style: const TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w600),
                        onChanged: (value) {
                          cvvNumber.value = value.replaceAll(' ', '');
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
}

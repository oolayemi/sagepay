<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

Flutter plugin for sagepay SDK


## Getting started

To use this plugin, add sagepay as a dependency in your pubspec.yaml file.

## How to Use
This plugin uses two APIs

1. Create a  SagePay instance by calling the constructor SagePay. The constructor accepts a required instance of the following: 
context, business, reference, callbackUrl, amount, token  It returns an instance of SagePay which we then call the async method .chargeTransaction() on.

```dart
import 'package:sagepay/sagepay.dart';
final sagePay = SagePay(
      context: context,
      amount: 100,
      reference: "jDSiFGdidHSddd",
      callbackUrl: "http://cspydo.com.ng",
      token: "SCSec-L-573d15f6************71ca6ecee9f6",
      business: Business(name: "Tech4Me2", email: "csamsonok@gmail.com"),
    );

PaymentResponse response = await sagePay.chargeTransaction();
```

2. Handle the response
   Calling the .chargeTransaction() method returns a Future
   of PaymentResponse which we await for the actual response as seen above.

```dart
const like = 'sample';
```

## Additional information



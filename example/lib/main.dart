import 'package:flutter/material.dart';
import 'package:sagepay/sagepay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SagePay Example',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SagePay Example"),
      ),
      body: Center(
        child: SizedBox(
          child: ElevatedButton(
            onPressed: () => gotoPaymentGateway(),
            child: const Text('Go to SagePay Checkout'),
          ),
        )
      ),
    );
  }

  gotoPaymentGateway() async {
    final sagePay = SagePay(
      context: context,
      amount: 100,
      reference: "{{randomly generated string}}",
      callbackUrl: "{{call back url}}",
      token: "{{Secret Key}}",
      business: Business(name: "{{business name}}", email: "{{business email}}"),
    );

    PaymentResponse? response = await sagePay.chargeTransaction();

    if (response != null) {
      if(response.success!) {
        //handle success response
      } else {
        //Handle not successful
      }
    } else {
      //User cancelled checkout
    }
  }
}

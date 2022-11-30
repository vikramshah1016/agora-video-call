import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';

import '../utils/api_client.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verificationId = "";
  static String mobileNumber = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  var phone = '';
  String appSignatureID = "";
  String _mobileNumber = '';
  List<SimCard> _simCard = <SimCard>[];
// print("_simCard");

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
    print("check permission granted");
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        print("permissin granted successfully ");
        initMobileNumberState();
      } else {}
    });
    initMobileNumberState();
  }

  Future<void> initMobileNumberState() async {
    print("initMobileNumberState");
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      List<SimCard> simCard1 = (await MobileNumber.getSimCards)!;
      setState(() {
        _simCard = simCard1;
      });
      _displayDialog(context);
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}' ");
    }
    // if (!mounted) return;
    // setState(() {});
  }

  Widget fillCards(BuildContext context) {
    List<Widget> widgets = _simCard
        .map((SimCard sim) => TextButton(
        onPressed: () {
          var simNumber = sim.number!;
          var prefix = simNumber.substring(0,2);
          var updatedText = simNumber.substring(2);
          _phoneTextController.value = _phoneTextController.value.copyWith(
            text: updatedText,
            selection: TextSelection.collapsed(offset: updatedText.length),
          );
          countryController.value = countryController.value.copyWith(
            text: prefix,
            selection: TextSelection.collapsed(offset: prefix.length),
          );
          Navigator.pop(context);
        },
        child: Text(
          '${sim.number}',
          style: TextStyle(fontSize: 25),
        )))
        .toList();
    return ListBody(children: widgets);
  }

  Future<void> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select Phone number"),
            content: SingleChildScrollView(child: fillCards(context)),
          );
        });
  }

  void sendOtp() async {
    try {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Loading......'),
        backgroundColor: Colors.green,
      ));

      var response = await ApiClient().login({'mobile':MyPhone.mobileNumber});

      if(!response.error){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ));

        Navigator.pushNamed(context,'verify');

      }else{
        Navigator.pushNamed(context,'phone');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Somting went wrong.!"),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "phone",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // fillCards(),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          controller: _phoneTextController,
                          onTap: () {
                            if (_phoneTextController.value.text.isEmpty) {
                              _displayDialog(context);
                            }
                          },
                          onChanged: (value) {
                            phone = value;
                            MyPhone.mobileNumber = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      MyPhone.mobileNumber = _phoneTextController.text;
                          sendOtp();
                    },
                    child: const Text("Send the code")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

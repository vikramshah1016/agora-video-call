import 'dart:async';
import 'package:agora_video_call/login/verify.dart';
import 'package:agora_video_call/servicies/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verificationId = "";
  static String mobileNumber = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

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
      List<SimCard> _simCard1 = (await MobileNumber.getSimCards)!;
      print("await initMobileNumberState _simCard1");
      setState(() {
        _simCard = _simCard1;
      });
      _displayDialog(context);
      print(_mobileNumber);
      print("_simCard");
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
          var prefix = simNumber.substring(0, 3);
          var updatedText = simNumber.substring(3);
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
            title: Text("Select Phone number"),
            content: SingleChildScrollView(child: fillCards(context)),
          );
        });
  }

  Future<void> _login() async{
    String phonenumber = _phoneTextController.text.trim();
    loginService loginservice = new loginService(mobilenumber:phonenumber);
    dynamic response = await loginservice.login();
    if(response.statusCode == 200){
      print(response.body);
      // Navigator.pushNamed(context, 'verify');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyVerify(loginservice: loginservice),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
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
              SizedBox(
                height: 25,
              ),
              Text(
                "phone",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
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
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // fillCards(),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          controller: _phoneTextController,
                          onTap: () {
                            if (_phoneTextController.value.text.length == 0) {
                              _displayDialog(context);
                            }
                          },
                          onChanged: (value) {
                            phone = value;
                            MyPhone.mobileNumber = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
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
                      _login();
                      // Navigator.pushNamed(context, 'verify');
                      // await FirebaseAuth.instance.verifyPhoneNumber(
                      //   phoneNumber: '${countryController.text + phone}',
                      //   verificationCompleted:
                      //       (PhoneAuthCredential credential) {},
                      //   verificationFailed: (FirebaseAuthException e) {},
                      //   codeSent:
                      //       (String verificationId, int? resendToken) async {
                      //     MyPhone.verificationId = verificationId;
                      //
                      //     appSignatureID = await SmsAutoFill().getAppSignature;
                      //     log('your message here ${appSignatureID}');
                      //
                      //     Navigator.pushNamed(context, 'verify');
                      //
                      //     log('dsadsa');
                      //   },
                      //   codeAutoRetrievalTimeout: (String verificationId) {},
                      // );
                    },
                    child: Text("Send the code")),
              ),

              // SizedBox(
              //   width: double.infinity,
              //   height: 45,
              //   child:fillCards()),
            ],
          ),
        ),
      ),
    );
  }
}

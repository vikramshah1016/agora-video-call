
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:agora_video_call/static/static_values.dart';

class loginService {

  String mobilenumber;
  String otp="";

   loginService({required this.mobilenumber});

  Future<http.Response> login() async {
    late final response;

    var ApiUrl = StaticValues.apiURL;
    try {
      response = await http.post(
        Uri.parse("$ApiUrl/login"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(<String, String>{
          'mobile': mobilenumber
        }),
      );
    }
    catch (e) {
      log(e.toString());
    }
    print(response);
    return response;
  }

  Future<http.Response> phoneVerify(String _otp) async {
    late final response;

    var ApiUrl = StaticValues.apiURL;
    try {
      response = await http.post(
        Uri.parse("$ApiUrl/verify-otp"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(<String, String>{
          'mobile': mobilenumber,
          'otp':_otp
        }),
      );
    }
    catch (e) {
      log(e.toString());
    }
    print(response);
    return response;

  }
}
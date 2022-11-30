import 'dart:convert';
import 'package:agora_video_call/model/SendOtp.dart';
import 'package:agora_video_call/model/VerifyOtp.dart';
import 'package:http/http.dart' as http;

import '../model/Contact.dart';

class ApiClient {
  final String baseUrl = "http://callapp.quantuminfoway.com/api";
  String? _token;

  Future<SendOtp> login(data) async {
    print(data);
    final response = await http.post(Uri.parse("${baseUrl}/login"),
        body: jsonEncode(data), headers: _setHeaders());

    if (response.statusCode == 200) {
      return SendOtp.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<VerifyOtp> verifyOtp(data) async {
    print(data);
    final response = await http.post(Uri.parse("${baseUrl}/verify-otp"),
        body: jsonEncode(data), headers: _setHeaders());

    if (response.statusCode == 200) {
      return VerifyOtp.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<Contact> contactList(token) async {
    _token = token;
    print(_token);
    final response = await http.get(Uri.parse("${baseUrl}/contact-list"),headers: _setHeaders());
    print(response.body);
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get data');
    }
  }
  // Future<RegisterDeviceInfo> registerDeviceInfo(url, data,token) async {
  //   _token = token;
  //   final response = await http.post(Uri.parse("${baseUrl}register-device-info"),
  //       body: jsonEncode(data), headers: _setHeaders());
  //   print(response.body);
  //   print(data);
  //   if (response.statusCode == 200) {
  //     return RegisterDeviceInfo.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to get data');
  //   }
  // }

  // Future<RegisterDevice> registerDevice(url, data,token) async {
  //   _token = token;
  //   final response = await http.post(Uri.parse("${baseUrl}register-device"),
  //       body: jsonEncode(data), headers: _setHeaders());
  //   print(response.body);
  //   print(data);
  //   if (response.statusCode == 200) {
  //     return RegisterDevice.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to get data');
  //   }
  // }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization':'Bearer $_token'
      };
}

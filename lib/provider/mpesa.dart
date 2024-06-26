import 'dart:convert';
import 'dart:io';
import 'package:event_ticketing_mobile_app/utilities/endpoint.dart';
import 'package:event_ticketing_mobile_app/utilities/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PaymentProvider extends ChangeNotifier {
  String? _token;

  String generateTimestamp() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    return formatter.format(now);
  }

  String generatePassword(
      String businessShortCode, String passKey, String timestamp) {
    final stringToEncode = '$businessShortCode$passKey$timestamp';
    final bytes = utf8.encode(stringToEncode);
    final password = base64.encode(bytes);
    return password;
  }

  Future<String?> initiatePayment(String phoneNumber, dynamic amount) async {
    final phone = "254${phoneNumber.substring(1)}";

    final timeStamp = generateTimestamp();
    final password = generatePassword(shortCode, mpesaPassKey, timeStamp);
    final token = await _getAccessToken();
    if (token == null) {
      return null;
    }

    _token = token;

    notifyListeners();

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final payload = {
      'BusinessShortCode': shortCode,
      'Password': password,
      'Timestamp': timeStamp,
      'TransactionType': 'CustomerPayBillOnline',
      'Amount': amount,
      'PartyA': phone,
      'PartyB': shortCode,
      'PhoneNumber': phone,
      'CallBackURL': callbackApiUrl,
      'AccountReference': 'Payments',
      'TransactionDesc': 'customers payment mobile',
    };

    try {
      final response = await http.post(
        Uri.parse(initatePaymentUrl),
        headers: headers,
        body: json.encode(payload),
      );

      print(
          "________________********INITIATE PAY RESPONSE**********____________$response");

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        print(
            "________________********INITIATE PAY FAILED**********____________$responseData");

        return null;
      }

      return responseData['CheckoutRequestID'];
    } on SocketException {
      errortoast('Check Your Internet Connection and Try Again');
      return null;
    } catch (e) {
      print('++++++initiate pay error++++++ $e');
      return null;
    }
  }

  Future<String?> checkPaymentStatus(String checkoutRequestID) async {
    final timeStamp = generateTimestamp();

    final password = generatePassword(shortCode, mpesaPassKey, timeStamp);

    final headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };

    final payload = {
      'BusinessShortCode': shortCode,
      'Password': password,
      'Timestamp': timeStamp,
      'CheckoutRequestID': checkoutRequestID,
    };

    try {
      final response = await http.post(
        Uri.parse(checkPaymentUrl),
        headers: headers,
        body: json.encode(payload),
      );

      final responseData = json.decode(response.body);

      print(
          "_______________************PAYMENT CHECKKKKK  RESPONSE********_____________$responseData");

      if (response.statusCode != 200) {
        return null;
      }

      return responseData["ResultCode"];
    } catch (e) {
      print(
          "_______________************PAYMENT CHECK ERROR********_____________$e");

      return null;
    }
  }

  Future<String?> _getAccessToken() async {
    try {
      const url =
          'https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';

      final headers = {
        "Authorization":
            "Basic ${base64.encode(utf8.encode('$mpesaClientKey:$mpesaClientSecret'))}",
        'Content-Type': 'application/json'
      };
      print(
          "________________********ACCESS_TOKEN_HEADERS**********____________$headers");

      final response =
          await http.get(Uri.parse(accessTokenurl), headers: headers);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        final accessToken = responseData['access_token'];
        print(
            "________________********ACCESS_TOKEN**********____________$responseData");
        return accessToken;
      }
      print(
          "________________********ACCESS_TOKEN**********____________${response.statusCode}");
      return null;
    } on SocketException {
      return null;
    } catch (e) {
      print(
          "________________********ACCESS_TOKEN_ERROR**********____________$e");
      return null;
    }
  }
}

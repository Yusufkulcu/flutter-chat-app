import 'dart:convert';
import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  static Future<http.Response> loginAction(
      PhoneCountryData areaCode, String phoneNumber) async {
    final http.Response response = await http.post(
      Uri.parse("$apiEndpoint/register-user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'areaCode': areaCode.phoneCode.toString(),
          'phoneNumber': phoneNumber,
        },
      ),
    );
    return response;
  }

  static Future<bool> updateUser(
      String userID, Map<String, dynamic> updateData) async {
    final http.Response response = await http.post(
      Uri.parse("$apiEndpoint/update-user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'userID': userID,
          'updateData': updateData,
        },
      ),
    );

    final responseBody = jsonDecode(response.body);
    print(responseBody);

    if (responseBody["status"] == "true") {
      return true;
    }
    return false;
  }

  static Future<bool> deleteChat(MessageModel messageModel) async {
    final prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      Uri.parse("$apiEndpoint/delete-chat"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'userID': prefs.getString("userID"),
          'messageHash': messageModel.message_hash,
        },
      ),
    );

    final responseBody = jsonDecode(response.body);
    print(responseBody);
    if (responseBody["status"] == "true") {
      return true;
    }
    return false;
  }

  static Future<UserModel> getUserDataFunction() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
        '$apiEndpoint/get-user-data?userID=${prefs.getString("userID")}',
      ),
    );
    print(response.body);
    return UserModel.fromJson(jsonDecode(response.body)["userData"]);
  }

  static Future<List<UserModel>> getAllUser() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
        '$apiEndpoint/get-all-user-list?userID=${prefs.getString("userID")}',
      ),
    );
    print(response.body);
    var jsonVeri = json.decode(response.body);
    var jsonArray = jsonVeri["userData"] as List;
    var list = jsonArray
        .map((jsonArrayObject) => UserModel.fromJson(jsonArrayObject))
        .toList();
    return list;
  }

  static Future<List<MessageModel>> getMessageList() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
        '$apiEndpoint/get-message-list?userID=${prefs.getString("userID")}',
      ),
    );
    print(response.body);
    var jsonVeri = json.decode(response.body);
    var jsonArray = jsonVeri["messageData"] as List;
    var list = jsonArray
        .map((jsonArrayObject) => MessageModel.fromJson(jsonArrayObject))
        .toList();
    return list;
  }

  static Future<Map<String, dynamic>> chatDetailQuery(
      String userID, String targetID) async {
    final http.Response response = await http.post(
      Uri.parse("$apiEndpoint/get-messages-by-user"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'userID': userID,
          'targetID': targetID,
          'date' : DateTime.now().millisecondsSinceEpoch
        },
      ),
    );
    final responseBody = jsonDecode(response.body);
    print(responseBody);
    if (responseBody["status"] == "true") {
      return {
        "status" : true,
        "messages" : responseBody["messageData"]
      };
    }
    return {
      "status" : false,
    };
  }
}

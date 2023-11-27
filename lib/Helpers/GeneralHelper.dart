import 'package:chatappyenitasarim/Models/MessageDetailModel.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const apiEndpoint = "https://chatappapi.yusufkulcu.com.tr/api";
const socketUrl = "http://185.136.206.33:5000";

IO.Socket? socket;

class GeneralHelper {
  static void connectSocket() async {
    final pref = await SharedPreferences.getInstance();
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'reconnection': true,
      'autoConnect': true
    });
    socket!.connect();
    socket!.onConnect((data) => socket!.emit("loginSocket", pref.getString("userID")));
  }

  static MessageDetailModel sendMessage({
    required String userID,
    required String targetID,
    required String message,
    required MessageModel messageModel,
    required TextEditingController textEditingController,
  }) {
    textEditingController.clear();
    final rs = RandomString();
    String randomString = rs.getRandomString(
      lowersCount: 20,
      uppersCount: 20,
      numbersCount: 20,
      specialsCount: 0,
    );

    MessageDetailModel messageDetailModel = MessageDetailModel(
      messageDetail_hash: randomString,
      messageDetail_messageHash: messageModel.message_hash,
      messageDetail_sendUser: userID,
      messageDetail_receiverUser: targetID,
      messageDetail_messageDetail: message,
      messageDetail_messageType: "text",
      messageDetail_messageReadStatus: "notRead",
      messageDetail_firstTestMessage: "0",
      messageDetail_messageDate:
          DateTime.now().millisecondsSinceEpoch.toString(),
    );

    socket!.emit("sendMessage", {
      "targetId": targetID,
      "messageDetailModel" : messageDetailModel.toJson(),
      "messageModel" : messageModel.toJson()
    });

    return messageDetailModel;
  }

  static void showSnackbarDialog(BuildContext context, Text text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: text,
      backgroundColor: color,
      action: SnackBarAction(
        label: 'Tamam',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }

  static UserModel getOppositeUserData(
      {required UserModel senderData,
      required UserModel receiverData,
      required String userId}) {
    if (senderData.id == userId) {
      return receiverData;
    } else {
      return senderData;
    }
  }

  static String getMessageDate(MessageDetailModel messageDetailModel) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(messageDetailModel.messageDetail_messageDate),
        isUtc: false);
    final diff =
        dateTimeDiff(int.parse(messageDetailModel.messageDetail_messageDate));
    print(diff);
    if (diff["minutesDiff"] < (24 * 60)) {
      return DateFormat.Hm("tr").format(date);
    } else if (diff["dayDiff"] == 1) {
      return "Dün";
    } else if (diff["minutesDiff"] > (24 * 60) &&
        diff["minutesDiff"] < (7 * (24 * 60))) {
      return DateFormat.EEEE("tr").format(date);
    } else {
      return DateFormat.yMMMd("tr").format(date);
    }
  }

  static String getMessageSpecificDate(MessageDetailModel messageDetailModel, String type) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(messageDetailModel.messageDetail_messageDate),
        isUtc: false);
    if(type=="hour") {
      return DateFormat.Hm("tr").format(date);
    }else if(type=="fulldate") {
      return DateFormat.yMMMd("tr").format(date);
    }else if(type=="day") {
      return DateFormat.EEEE("tr").format(date);
    }else {
      return DateFormat.yMMMd("tr").format(date);
    }
  }

  static Map<String, dynamic> dateTimeDiff(int inputDateMiliseconds) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(inputDateMiliseconds, isUtc: false);
    Duration diff = DateTime.now().difference(date);
    return {
      "dayDiff": diff.inDays,
      "hoursDiff": diff.inHours,
      "minutesDiff": diff.inMinutes,
      "secondsDiff": diff.inSeconds,
    };
  }
}

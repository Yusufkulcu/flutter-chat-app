import 'package:chatappyenitasarim/Models/MessageDetailModel.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';

class MessageModel {

  String message_id;
  String message_hash;
  String message_senderUser;
  String message_receiverUser;
  String message_isGroup;
  UserModel senderData;
  UserModel receiverData;
  MessageDetailModel? lastMessage;
  List<MessageDetailModel>? allMessage;

  MessageModel({
    required this.message_id,
    required this.message_hash,
    required this.message_senderUser,
    required this.message_receiverUser,
    required this.message_isGroup,
    required this.senderData,
    required this.receiverData,
    this.lastMessage,
    this.allMessage,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    message_id: json["message_id"].toString(),
    message_hash: json["message_hash"],
    message_senderUser: json["message_senderUser"],
    message_receiverUser: json["message_receiverUser"],
    message_isGroup: json["message_isGroup"].toString(),
    senderData: UserModel.fromJson(json["get_sender_data"]),
    receiverData: UserModel.fromJson(json["get_receiver_data"]),
    lastMessage: json["get_last_message"] == null ? null : MessageDetailModel.fromJson(json["get_last_message"]) ,
    allMessage: json["get_all_message"] == null ? null : List<MessageDetailModel>.from(json["get_all_message"]!.map((x) => MessageDetailModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message_id": message_id,
    "message_hash": message_hash,
    "message_senderUser": message_senderUser,
    "message_receiverUser": message_receiverUser,
    "message_isGroup": message_isGroup,
    "senderData": senderData.toJson(),
    "receiverData": receiverData.toJson(),
    "lastMessage": lastMessage?.toJson(),
    "allMessage":  allMessage == null ? [] : List<dynamic>.from(allMessage!.map((x) => x.toJson())),
  };



}

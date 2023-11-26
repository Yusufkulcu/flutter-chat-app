import 'dart:convert';
import 'dart:typed_data';

import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Helpers/HttpHelper.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:chatappyenitasarim/Screens/ChatDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListCardWidget extends StatelessWidget {
  const UserListCardWidget({super.key, required this.userModel, required this.userID});
  final UserModel userModel;
  final String userID;

  @override
  Widget build(BuildContext context) {
    Uint8List base64ProfileImage = Base64Decoder().convert(userModel.profilePhotoBase64);
    return InkWell(
      onTap: () async {
        final response = await HttpHelper.chatDetailQuery(userID, userModel.id);
        if(response["status"] == true) {
          Get.to(ChatDetailScreen(messageModel: MessageModel.fromJson(response["messages"]), userID: userID,), transition: Transition.fade);
        }else {
          GeneralHelper.showSnackbarDialog(context, Text("Sistemsel hata oluştu.",style: TextStyle(color: Colors.white),), Colors.red);
        }
      },
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black12, width: 2.0),
                borderRadius: BorderRadius.circular(20.0)),
            child: ListTile(
              title: Text(userModel.name!),
              isThreeLine: true,
              subtitle: Text(userModel.bio!,overflow: TextOverflow.ellipsis,),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Image.memory(
                  base64ProfileImage,
                  height: 80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

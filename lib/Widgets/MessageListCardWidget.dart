import 'dart:convert';
import 'dart:typed_data';
import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Helpers/HttpHelper.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:chatappyenitasarim/Screens/ChatDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class MessageListCardWidget extends StatefulWidget {
  const MessageListCardWidget({
    super.key,
    required this.messageModel,
    required this.userID,
    required this.updateChat,
  });

  final MessageModel messageModel;
  final String userID;
  final Function updateChat;

  @override
  State<MessageListCardWidget> createState() => _MessageListCardWidgetState();
}

class _MessageListCardWidgetState extends State<MessageListCardWidget> {
  late UserModel oppositeUserData;

  @override
  void initState() {
    super.initState();
    oppositeUserData = GeneralHelper.getOppositeUserData(
        senderData: widget.messageModel.senderData,
        receiverData: widget.messageModel.receiverData,
        userId: widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    Uint8List base64ProfileImage =
        Base64Decoder().convert(oppositeUserData.profilePhotoBase64);
    // print(int.parse(widget.messageModel.lastMessage.messageDetail_messageDate));
    return InkWell(
      onTap: () async {
        final response = await HttpHelper.chatDetailQuery(widget.userID, oppositeUserData.id);
        if(response["status"] == true) {
          Get.to(ChatDetailScreen(messageModel: MessageModel.fromJson(response["messages"]), userID: widget.userID,), transition: Transition.fade);
        }else {
          GeneralHelper.showSnackbarDialog(context, Text("Sistemsel hata oluştu.",style: TextStyle(color: Colors.white),), Colors.red);
        }
      },
      child: Slidable(
        key: ValueKey(widget.messageModel.lastMessage!.messageDetail_hash),
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog.adaptive(
                        content: Text(
                            "Sohbeti silmek istediğinize emin misiniz, bu işlem geri alınamaz !"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                            },
                            child: Text("İptal et"),
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await HttpHelper.deleteChat(
                                  widget.messageModel);
                              if (result == true) {
                                Navigator.of(context).pop();
                                GeneralHelper.showSnackbarDialog(
                                  context,
                                  Text(
                                    "Sohbet silindi.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Colors.green,
                                );
                                widget.updateChat();
                              } else {
                                GeneralHelper.showSnackbarDialog(
                                  context,
                                  Text(
                                    "Sohbet silinemedi, sistemsel hata oluştu.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Colors.green,
                                );
                              }
                            },
                            child: Text("Evet, eminim"),
                          ),
                        ],
                      );
                    });
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Sil',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0)),
              child: ListTile(
                title: Text(oppositeUserData.name!),
                isThreeLine: true,
                subtitle: Row(
                  children: [
                    Icon(Icons.check),
                    Text(widget
                        .messageModel.lastMessage!.messageDetail_messageDetail)
                  ],
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.memory(
                    base64ProfileImage,
                    height: 80,
                  ),
                ),
                trailing: Text(
                  GeneralHelper.getMessageDate(widget.messageModel.lastMessage!),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Models/MessageDetailModel.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Widgets/ChatDetailMessageListCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.messageModel,
    required this.userID,
  });

  final MessageModel messageModel;
  final String userID;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isWriting = false;
  ScrollController scrollController = ScrollController();
  late Timer _timer;
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isAudioRecording = false;

  void setMessageList(MessageDetailModel messageDetailModel) {
    final List<MessageDetailModel>? messageList =
        widget.messageModel.allMessage;
    setState(() {
      messageList!.add(messageDetailModel);
    });
  }

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();

    socket!.on("onMessage", (data) {
      final MessageDetailModel messageDetailModel =
          MessageDetailModel.fromJson(data["messageDetailModel"]);
      setMessageList(messageDetailModel);
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
    _timer = Timer(const Duration(milliseconds: 100), () async {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> startAudioRecord() async {
    try {
      if (await audioRecord.hasPermission()) {
        setState(() {
          isAudioRecording = true;
        });
        await audioRecord.start(const RecordConfig(),
            path: 'aFullPath/myFile.m4a');
      }
    } catch (e) {
      print("Kayıt başlamadı $e");
    }
  }

  Future<void> stopAudioRecord() async {
    try {
      setState(() {
        isAudioRecording = false;
      });
      final String? recordPath = await audioRecord.stop();
      print(recordPath);
    } catch (e) {
      print("Kayıt durdurulamadı $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final oppositeData = GeneralHelper.getOppositeUserData(
      senderData: widget.messageModel.senderData,
      receiverData: widget.messageModel.receiverData,
      userId: widget.userID,
    );
    Uint8List base64ProfileImage =
        Base64Decoder().convert(oppositeData.profilePhotoBase64);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        titleSpacing: 5,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                size: 28,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xffffc746),
              child: Image.memory(
                base64ProfileImage,
                height: 36,
                width: 36,
              ),
            ),
          ],
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              oppositeData.name!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Son görülme 22:22",
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.call,
                size: 28,
              )),
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call, size: 35)),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index == widget.messageModel.allMessage!.length) {
                  return Container(
                    height: 80,
                  );
                }
                print(widget.messageModel.allMessage!.length);
                final singleMessageData =
                    widget.messageModel.allMessage![index];
                return ChatDetailMessageListCard(
                  userID: widget.userID,
                  messageDetailModel: singleMessageData,
                );
              },
              itemCount: widget.messageModel.allMessage!.length + 1,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.attach_file_outlined,
                      size: 28,
                    ),
                  ),
                  Container(
                    width: isWriting == false ? width - 150 : width - 100,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: messageController,
                        onChanged: (value) {
                          print(isWriting);
                          if (value.isNotEmpty) {
                            setState(() {
                              isWriting = true;
                            });
                          } else {
                            setState(() {
                              isWriting = false;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Mesajınızı yazınız.",
                          contentPadding: EdgeInsets.all(5),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  if (isWriting == false)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 28,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if(isAudioRecording == true) {
                              stopAudioRecord();
                            }else {
                              startAudioRecord();
                            }
                          },
                          icon: const Icon(
                            Icons.mic_outlined,
                            size: 28,
                          ),
                        ),
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IconButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            setState(() {
                              isWriting = false;
                            });
                            MessageDetailModel response =
                                GeneralHelper.sendMessage(
                                    userID: widget.userID,
                                    targetID: oppositeData.id,
                                    messageModel: widget.messageModel,
                                    textEditingController: messageController,
                                    message: messageController.text);
                            setMessageList(response);
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent + 100,
                              duration: Duration(milliseconds: 1),
                              curve: Curves.easeOut,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 35,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

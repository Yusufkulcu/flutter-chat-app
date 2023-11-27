import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Models/MessageDetailModel.dart';
import 'package:chatappyenitasarim/Models/MessageModel.dart';
import 'package:chatappyenitasarim/Widgets/ChatDetailMessageListCard.dart';
import 'package:chatappyenitasarim/Providers/ChatDetailProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.messageModel,
    required this.userID,
  });

  final MessageModel messageModel;
  final String userID;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isWriting = false;
  ScrollController scrollController = ScrollController();
  late Timer _timer;
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isAudioRecording = false;
  bool isLastAudioPlaying = false;
  late Widget textOrAudio;
  late String? lastAudioRecordPAth;

  void setMessageList(MessageDetailModel messageDetailModel) {
    final List<MessageDetailModel>? messageList =
        widget.messageModel.allMessage;
    setState(() {
      messageList!.add(messageDetailModel);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref
          .watch(chatDetailProviderStatement)
          .setWidgetForTextField(messageController: messageController);
    });
    if (socket == null) {
      GeneralHelper.connectSocket();
    }
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
    super.initState();
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
      Map<Permission, PermissionStatus> permissions = await [
        Permission.storage,
        Permission.microphone,
      ].request();

      // bool permissionsGranted = permissions[Permission.storage]!.isGranted &&
      //     permissions[Permission.microphone]!.isGranted;

      if (await audioRecord.hasPermission()) {
        setState(() {
          isAudioRecording = true;
          textOrAudio = const Padding(
            padding: EdgeInsets.all(8),
            child: Text("Sesiniz kayıt ediliyor."),
          );
        });

        Directory appDocDirectory = await getApplicationDocumentsDirectory();
        Directory appFolder = Directory("${appDocDirectory.path}/recording");
        bool appFolderExists = await appFolder.exists();
        var createdPath = "";
        if (!appFolderExists) {
          final created = await appFolder.create(recursive: true);
          createdPath = created.path;
          print(created.path);
        } else {
          createdPath = appFolder.path;
        }
        final filepath =
            '$createdPath/${DateTime.now().millisecondsSinceEpoch}.rn';
        print(filepath);

        await audioRecord.start(const RecordConfig(), path: filepath);
      }
    } catch (e) {
      print("Kayıt başlamadı $e");
    }
  }

  Future<void> stopAudioRecord() async {
    try {
      final String? recordPath = await audioRecord.stop();
      print(recordPath);
      setState(() {
        isAudioRecording = false;
        textOrAudio = Row(
          children: [
            InkWell(
              onTap: () {
                playLastAudioRecord();
              },
              child: Icon(
                isLastAudioPlaying == true
                    ? Icons.stop_circle_outlined
                    : Icons.play_arrow,
                size: 30,
              ),
            )
          ],
        );
        lastAudioRecordPAth = recordPath!;
      });
      // await audioPlayer.play(UrlSource(recordPath!));
    } catch (e) {
      print("Kayıt durdurulamadı $e");
    }
  }

  Future<void> playLastAudioRecord() async {
    if (lastAudioRecordPAth == null) return;
    setState(() {
      isLastAudioPlaying = true;
    });
    await audioPlayer.play(UrlSource(lastAudioRecordPAth!), volume: 100);
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isLastAudioPlaying = false;
        textOrAudio = TextFormField(
          controller: messageController,
          onChanged: (value) {
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
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final oppositeData = GeneralHelper.getOppositeUserData(
      senderData: widget.messageModel.senderData,
      receiverData: widget.messageModel.receiverData,
      userId: widget.userID,
    );

    final getChatDetailProvider = ref.watch(chatDetailProviderStatement);

    Uint8List base64ProfileImage =
        Base64Decoder().convert(oppositeData.profilePhotoBase64);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.video_call,
              size: 35,
            ),
          ),
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
                    width: getChatDetailProvider.isMessageWriting == false
                        ? width - 150
                        : width - 100,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: getChatDetailProvider.textFieldOrAudioPlayer,
                    ),
                  ),
                  if (getChatDetailProvider.isMessageWriting == false)
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
                            if (getChatDetailProvider.isAudioRecording ==
                                true) {
                              stopAudioRecord();
                            } else {
                              startAudioRecord();
                            }
                          },
                          icon: Icon(
                            getChatDetailProvider.isAudioRecording == true
                                ? Icons.stop_circle_outlined
                                : Icons.mic_outlined,
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

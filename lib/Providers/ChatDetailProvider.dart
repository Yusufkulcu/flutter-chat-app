import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailProvider extends ChangeNotifier {
  Widget textFieldOrAudioPlayer = Container();
  bool isMessageWriting = false;
  bool isAudioRecording = false;
  bool isLastAudioPlaying = false;
  String lastAudioTiming = "0:00:00";


  setWidgetForTextField({
    required TextEditingController messageController,
  }) {
    textFieldOrAudioPlayer = TextFormField(
      controller: messageController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          isMessageWriting = true;
        } else {
          isMessageWriting = false;
        }
      },
      decoration: const InputDecoration(
        hintText: "Mesajınızı yazınız.",
        contentPadding: EdgeInsets.all(5),
        border: InputBorder.none,
      ),
    );
    notifyListeners();
  }

  setWidgetForCustom({required Widget widget}) {
    textFieldOrAudioPlayer = widget;
    notifyListeners();
  }

  setWidgetForAudioPlayer({
    required String filePath,
    required AudioPlayer audioPlayer,
    required TextEditingController messageController,
  }) {
    textFieldOrAudioPlayer = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              audioPlayer.stop();
              setWidgetForTextField(messageController: messageController);
            },
            child: const Icon(
              Icons.delete,
              size: 30,
            ),
          ),
          InkWell(
            onTap: () {
              isLastAudioPlaying = !isLastAudioPlaying;
              playLastAudioRecord(
                  recordPath: filePath,
                  audioPlayer: audioPlayer,
                  messageController: messageController);
              textFieldOrAudioPlayer = Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        audioPlayer.stop();
                        setWidgetForTextField(messageController: messageController);
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 30,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isLastAudioPlaying = !isLastAudioPlaying;
                        notifyListeners();
                      },
                      child: const Icon(
                        Icons.stop,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              );
              notifyListeners();
            },
            child: const Icon(
              Icons.play_arrow,
              size: 40,
            ),
          ),
        ],
      ),
    );
    notifyListeners();
  }

  Future<void> playLastAudioRecord({
    required String recordPath,
    required AudioPlayer audioPlayer,
    required TextEditingController messageController,
  }) async {
    print("oynadı");
    await audioPlayer.play(UrlSource(recordPath), volume: 100);
    audioPlayer.onPositionChanged.listen((Duration event) {
      print(event);
      lastAudioTiming = event.toString().split(".")[0];
      notifyListeners();
    });
    audioPlayer.onPlayerComplete.listen((event) {
      isLastAudioPlaying = false;
      setWidgetForAudioPlayer(
        filePath: recordPath,
        audioPlayer: audioPlayer,
        messageController: messageController,
      );
      lastAudioTiming = "0:00:00";
    });
  }
}

final chatDetailProviderStatement = ChangeNotifierProvider(
  (ref) => ChatDetailProvider(),
);

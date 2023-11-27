import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDetailProvider extends ChangeNotifier {
  Widget textFieldOrAudioPlayer = Container();
  bool isMessageWriting = false;
  bool isAudioRecording = false;

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

  setWidgetForAudioPlayer({
    required String filePath,
  }) {
    textFieldOrAudioPlayer = Row(
      children: [
        InkWell(
          onTap: () {},
          child: const Icon(
            Icons.play_arrow,
            size: 30,
          ),
        )
      ],
    );
    notifyListeners();
  }
}

final chatDetailProviderStatement = ChangeNotifierProvider(
  (ref) => ChatDetailProvider(),
);

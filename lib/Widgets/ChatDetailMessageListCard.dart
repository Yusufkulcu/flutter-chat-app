import 'package:chatappyenitasarim/Models/MessageDetailModel.dart';
import 'package:flutter/material.dart';

class ChatDetailMessageListCard extends StatefulWidget {
  const ChatDetailMessageListCard({
    super.key,
    required this.userID,
    required this.messageDetailModel,
  });

  final String userID;
  final MessageDetailModel messageDetailModel;

  @override
  State<ChatDetailMessageListCard> createState() =>
      _ChatDetailMessageListCardState();
}

class _ChatDetailMessageListCardState extends State<ChatDetailMessageListCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final messageData = widget.messageDetailModel;
    return Align(
      alignment: messageData.messageDetail_sendUser == widget.userID
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width - 45),
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          color: messageData.messageDetail_sendUser == widget.userID
              ? Color(0xff20a090)
              : Color(0xfff2f7fb),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 60,
                  top: 10,
                  bottom: 30,
                ),
                child: Text(
                  messageData.messageDetail_messageDetail,
                  style: TextStyle(
                    color: messageData.messageDetail_sendUser == widget.userID
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: messageData.messageDetail_sendUser == widget.userID
                    ? 0
                    : null,
                left: messageData.messageDetail_sendUser == widget.userID
                    ? null
                    : 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: messageData.messageDetail_sendUser != widget.userID ? 10 : 0,
                      ),
                      Text(
                        "22:22",
                        style: TextStyle(
                          color:
                              messageData.messageDetail_sendUser == widget.userID
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 5,),
                      if (messageData.messageDetail_sendUser == widget.userID)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.done_all,
                            color: messageData.messageDetail_messageReadStatus == "notRead" ? Colors.black : Colors.blue,
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

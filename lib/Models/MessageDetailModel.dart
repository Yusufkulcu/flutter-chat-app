class MessageDetailModel {

  String messageDetail_hash;
  String messageDetail_messageHash;
  String messageDetail_sendUser;
  String messageDetail_receiverUser;
  String messageDetail_messageDetail;
  String messageDetail_messageType;
  String messageDetail_messageReadStatus;
  String messageDetail_firstTestMessage;
  String messageDetail_messageDate;


  MessageDetailModel({
   required this.messageDetail_hash,
   required this.messageDetail_messageHash,
   required this.messageDetail_sendUser,
   required this.messageDetail_receiverUser,
   required this.messageDetail_messageDetail,
   required this.messageDetail_messageType,
   required this.messageDetail_messageReadStatus,
   required this.messageDetail_firstTestMessage,
   required this.messageDetail_messageDate,
});


  factory MessageDetailModel.fromJson(Map<String, dynamic> json) => MessageDetailModel(
    messageDetail_hash: json["messageDetail_hash"],
    messageDetail_messageHash: json["messageDetail_messageHash"],
    messageDetail_sendUser: json["messageDetail_sendUser"],
    messageDetail_receiverUser: json["messageDetail_receiverUser"].toString(),
    messageDetail_messageDetail: json["messageDetail_messageDetail"],
    messageDetail_messageType: json["messageDetail_messageType"],
    messageDetail_messageReadStatus: json["messageDetail_messageReadStatus"],
    messageDetail_firstTestMessage: json["messageDetail_firstTestMessage"],
    messageDetail_messageDate: json["messageDetail_messageDate"],
  );

  Map<String, dynamic> toJson() => {
    "messageDetail_hash": messageDetail_hash,
    "messageDetail_messageHash": messageDetail_messageHash,
    "messageDetail_sendUser": messageDetail_sendUser,
    "messageDetail_receiverUser": messageDetail_receiverUser,
    "messageDetail_messageDetail": messageDetail_messageDetail,
    "messageDetail_messageType": messageDetail_messageType,
    "messageDetail_messageReadStatus": messageDetail_messageReadStatus,
    "messageDetail_firstTestMessage": messageDetail_firstTestMessage,
    "messageDetail_messageDate": messageDetail_messageDate,
  };

}
class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  String? createdon;
  String? auctionLink;
  String? auctionType;

  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.seen,
    this.createdon,
    this.auctionLink,
    this.auctionType,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdOn"];
    auctionLink = map["auctionLink"]??'';
    auctionType = map["auctionType"]??'';
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdon,
      "auctionLink": auctionLink??'',
      "auctionType": auctionType??'',
    };
  }
}

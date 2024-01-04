import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/chatroom_model.dart';
import '../models/user_model.dart';

Uuid uuid = const Uuid();

Future<ChatroomModel?> getChatroomModel(UserModel targetUser) async {
  ChatroomModel? chatRoom;

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("chatrooms")
      .where("participants.${UserModel.loggedinUser!.id}", isEqualTo: true)
      .where("participants.${targetUser.id}", isEqualTo: true)
      .get();

  if (snapshot.docs.isNotEmpty) {
    var docData = snapshot.docs[0].data();
    ChatroomModel existingChatroom =
        ChatroomModel.fromMap(docData as Map<String, dynamic>);
    chatRoom = existingChatroom;
  } else {
    ChatroomModel newChatroom = ChatroomModel(
      chatroomId: uuid.v1(),
      lastMessage: "",
      participants: {
        UserModel.loggedinUser!.id.toString(): true,
        targetUser.id.toString(): true,
      },
    );

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(newChatroom.chatroomId)
        .set(newChatroom.toMap());

    chatRoom = newChatroom;
  }
  return chatRoom;
}

Future<ChatroomModel?> getChatroomModelAdmin(UserModel targetUser) async {
  ChatroomModel? chatRoom;

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("chatrooms")
      .where("participants.tBuAzA90NffCXIyfMiKR0Nw3RHc2", isEqualTo: true)
      .where("participants.${targetUser.id}", isEqualTo: true)
      .get();

  if (snapshot.docs.isNotEmpty) {
    var docData = snapshot.docs[0].data();
    ChatroomModel existingChatroom =
        ChatroomModel.fromMap(docData as Map<String, dynamic>);
    chatRoom = existingChatroom;
  } else {
    ChatroomModel newChatroom = ChatroomModel(
      chatroomId: uuid.v1(),
      lastMessage: "",
      participants: {
        'tBuAzA90NffCXIyfMiKR0Nw3RHc2': true,
        targetUser.id.toString(): true,
      },
    );

    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(newChatroom.chatroomId)
        .set(newChatroom.toMap());

    chatRoom = newChatroom;
  }
  return chatRoom;
}

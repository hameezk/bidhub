import 'package:bidhub/config/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/chatroom_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatroomModel chatRoom;
  final UserModel userModel;

  const ChatRoom({
    Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
  }) : super(key: key);

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.id,
        createdon: DateTime.now().toString(),
        text: msg,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatroomId)
          .set(widget.chatRoom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).canvasColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(widget.targetUser.image.toString()),
              child: const CircularProgressIndicator(
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.targetUser.name.toString(),
              style: const TextStyle(fontSize: 18),
              maxLines: 2,
            )
          ],
        ),
        // actions: [
        //   PopupMenuButton<int>(
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(
        //         value: 1,
        //         child: Row(
        //           children: [
        //             Icon(
        //               Icons.person,
        //               size: 30.0,
        //               color: Colors.blueGrey,
        //             ),
        //             SizedBox(
        //               // sized box with width 10
        //               width: 10,
        //             ),
        //             Text(
        //               "View Profile",
        //               style: TextStyle(
        //                 color: Colors.blueGrey,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       const PopupMenuItem(
        //         value: 2,
        //         child: Row(
        //           children: [
        //             Icon(
        //               CupertinoIcons.exclamationmark_shield,
        //               size: 30.0,
        //               color: Colors.blueGrey,
        //             ),
        //             SizedBox(
        //               width: 10,
        //             ),
        //             Text(
        //               "Report Chat",
        //               style: TextStyle(
        //                 color: Colors.blueGrey,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //     offset: const Offset(0, 40),
        //     color: Colors.grey[100],
        //     elevation: 2,
        //     onSelected: (value) {
        //       if (value == 1) {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) {
        //               return ViewProfile(
        //                 userModel: widget.userModel,
        //                 firebaseUser: widget.firebaseUser,
        //                 targetUserModel: widget.targetUser,
        //               );
        //             },
        //           ),
        //         );
        //       } else if (value == 2) {
        //         _showReportDialog(
        //           context,
        //           widget.targetUser.uid!,
        //           widget.userModel.uid!,
        //           widget.chatRoom.chatroomId!,
        //         );
        //       }
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.chatRoom.chatroomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        reverse: true,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return (currentMessage.sender == widget.userModel.id)
                              //  FOR LOGGED IN USER
                              ? ListTile(
                                  trailing: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.userModel.image.toString()),
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: containerColor,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ],
                                  ),
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              //  FOR TARGET USER
                              : ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        widget.targetUser.image.toString()),
                                    child: const CircularProgressIndicator(
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: textColorLight,
                                        ),
                                        child:
                                            Text(currentMessage.text.toString(),
                                                maxLines: 20,
                                                style: const TextStyle(
                                                  color: canvasColor,
                                                )),
                                      ),
                                    ],
                                  ),
                                  // subtitle: (),
                                  trailing: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                  ),
                                );
                        },
                        itemCount: dataSnapshot.docs.length,
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                            "An error occoured! Please check your internet connection "),
                      );
                    } else {
                      return Center(
                        child: Text("Say Hi to ${widget.targetUser.name}"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      style: const TextStyle(color: Colors.blueGrey),
                      decoration: const InputDecoration(
                        hintText: "Enter Message...",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

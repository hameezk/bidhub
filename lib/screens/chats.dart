import 'package:bidhub/config/bottombar.dart';
import 'package:bidhub/config/colors.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_helper.dart';
import '../models/chatroom_model.dart';
import 'chat_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("Chats"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatrooms")
                  .where("participants.${UserModel.loggedinUser!.id}",
                      isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    QuerySnapshot chatRoomSnapshot =
                        snapshot.data as QuerySnapshot;

                    return ListView.builder(
                      itemCount: chatRoomSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        ChatroomModel chatRoomModel = ChatroomModel.fromMap(
                            chatRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        Map<String, dynamic> participants =
                            chatRoomModel.participants!;

                        List<String> participantKeys =
                            participants.keys.toList();
                        participantKeys.remove(UserModel.loggedinUser!.id);

                        return FutureBuilder(
                          future: FirebaseHelper.getUserModelById(
                              participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModel targetUser =
                                    userData.data as UserModel;

                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatRoom(
                                          chatRoom: chatRoomModel,
                                          userModel: UserModel.loggedinUser!,
                                          targetUser: targetUser,
                                        );
                                      }),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    foregroundImage: NetworkImage(
                                        targetUser.image.toString()),
                                    child: const CircularProgressIndicator(),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        targetUser.name.toString(),
                                        style: const TextStyle(
                                            color: textColorDark,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      (targetUser.id ==
                                              'tBuAzA90NffCXIyfMiKR0Nw3RHc2')
                                          ? SizedBox(
                                              height: 20,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Image.asset(
                                                    'assets/verify.png'),
                                              ))
                                          : const Text('')
                                    ],
                                  ),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(
                                          chatRoomModel.lastMessage.toString())
                                      : const Text(
                                          "Say hi to your new friend!",
                                          style:
                                              TextStyle(color: textColorLight),
                                        ),
                                  trailing: IconButton(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) {
                                      //       return ViewProfile(
                                      //         userModel: widget.userModel,
                                      //         firebaseUser: widget.firebaseUser,
                                      //         targetUserModel: targetUser,
                                      //       );
                                      //     },
                                      //   ),
                                      // );
                                    },
                                    icon: const Icon(
                                      Icons.person,
                                      size: 40.0,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Text("No Chats"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            buildNavBar(context, 1),
          ],
        ),
      ),
    );
  }
}

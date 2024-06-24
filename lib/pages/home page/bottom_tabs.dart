import 'package:flutter/material.dart';
import 'package:leo_final/pages/games/games.dart';
import 'package:leo_final/pages/group/group.dart';
import 'package:leo_final/pages/profile/profile.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

Widget buildBottomTabs(int index){
  List<Widget> tabs = [
    tabBarView(),
    const Group(),
    const Games(),
    const Profile(),
  ];

  return tabs[index];
}

Widget tabBarView(){
  return  TabBarView(
    children: [
      ZIMKitConversationListView(
        onPressed: (context , conversation , defaultAction){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => ZIMKitMessageListPage(
            conversationID: conversation.id,
            conversationType: conversation.type,
            appBarActions: [
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.call)
              ),IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.video_call)
              ),
            ],
          ),
          ));
        },
      ),
      // ChatsTab(),
      const Center(child: Text('Status feature is coming soon')),
      const Center(child: Text('Call feature is coming soon')),
    ],
  );
}
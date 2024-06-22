
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../ChatsTab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}); 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const Icon(Icons.search, color: Colors.white),
            PopupMenuButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(child: const Text('New chat'),
                    onTap: (){
                     ZIMKit().showDefaultNewPeerChatDialog(context);
                    },
                  ),
                  const PopupMenuItem(child: Text('New Group')),
                 // const PopupMenuItem(child: Text('New Broadcast')),
                  const PopupMenuItem(child: Text('Linked Devices')),
                  const PopupMenuItem(child: Text('Starred Messages')),
                  const PopupMenuItem(child: Text('Settings')),
                ];
              },
            ),
          ],
          backgroundColor: const Color(0xff059FDA),
          title: Text('LEO-CHAT', style: TextStyle(color: Colors.white,
            fontWeight:FontWeight.w500,
            height: 1.9.h,
          )),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text('CHATS', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('STATUS', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('CALLS', style: TextStyle(color: Colors.white)),
              ),
            ],
            labelColor: Colors.white,
          ),
        ),
        body:  TabBarView(
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.blue.withOpacity(0.8),
          showSelectedLabels: false,
          elevation: 1,
          currentIndex: 1,
          items: [
            BottomNavigationBarItem(
              activeIcon: const Icon(Icons.chat,
                color: Colors.blue,
              ),
              icon: Icon(Icons.chat,
                color: Colors.blue.withOpacity(0.8),
              ),
              label: 'chat',
            ),BottomNavigationBarItem(
              activeIcon: const Icon(Icons.group,
                color: Colors.blue,
              ),
              icon: Icon(Icons.group,
                color: Colors.blue.withOpacity(0.8),
              ),
              label: 'group',
            ),BottomNavigationBarItem(
              activeIcon: const Icon(Icons.sports_basketball,
                color: Colors.blue,
              ),
              icon: Icon(Icons.sports_basketball,
                color: Colors.blue.withOpacity(0.8),
              ),
              label: 'games',
            ),BottomNavigationBarItem(
              activeIcon: const Icon(Icons.person,
                color: Colors.blue,
              ),
              icon: Icon(Icons.person,
                color: Colors.blue.withOpacity(0.8),
              ),
              label: 'profile',
            ),
          ],
        ),
        ),
  //    ),
    );
  }
}

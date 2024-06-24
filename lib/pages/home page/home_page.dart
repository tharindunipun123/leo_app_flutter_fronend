
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/home%20page/bloc/home_page_bloc.dart';
import 'package:leo_final/pages/home%20page/bloc/home_page_event.dart';
import 'package:leo_final/pages/home%20page/bottom_tabs.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'bloc/home_page_state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context,  state) =>
        Scaffold(
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
            bottom: state.index == 0 ? const TabBar(
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
            ) : null,
          ),
          body: buildBottomTabs(state.index),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.grey,
            elevation: 1,
            type: BottomNavigationBarType.fixed,
            currentIndex: state.index!,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: (index){
              context.read<HomePageBloc>().add(IndexEvent(index: index));
            },
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
      ),
    );
  }
}

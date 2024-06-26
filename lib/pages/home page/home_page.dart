import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/contacts/contact_screen.dart';
import 'package:leo_final/pages/home%20page/bloc/home_page_bloc.dart';
import 'package:leo_final/pages/home%20page/bloc/home_page_event.dart';
import 'package:leo_final/pages/home%20page/bottom_tabs.dart';
import 'package:leo_final/zego%20files/initial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../group/GroupMembers.dart';
import '../log in page/log_in_page.dart';
import 'bloc/home_page_state.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  final String userId;
  final String name;
  const MyHomePage(
      {super.key,
      required this.userId,
      required this.name,
      required String about});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeZIMKitAndLoadChats();
    _fetchContacts();
  }

  Future<void> _initializeZIMKitAndLoadChats() async {
    await _initializeZIMKit();
    await _loadChats();
  }

  Future<void> _initializeZIMKit() async {
    await ZIMKit().init(
      appID: Initial.id,
      appSign: Initial.signIn,
    );
    await ZIMKit().connectUser(
      id: widget.userId,
      name: widget.userId, // Replace with an appropriate user name
    );
  }

  Future<void> _loadChats() async {
    // Fetch chats or any necessary data
    //  await ZIMKit().getConversation();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user.json');
      if (await file.exists()) {
        await file.delete();
        // Ensure ZIMKit cleanup if necessary
        // Use appropriate method if available
        await ZIMKit()
            .disconnectUser(); // Replace with actual method if different
        print('User data deleted.');
      } else {
        print('No user data found to delete.');
      }
    } catch (e) {
      print('Error deleting user data: $e');
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _fetchUsers() async {
    try {
      // Simulating an API call with a delay
      await Future.delayed(const Duration(seconds: 2));
      // List<dynamic> fetchedUsers = await ApiService.fetchUsers();
      setState(() {
        // users = fetchedUsers.cast<String>();
        isLoading = false;
        for (var user in users) {
          print('User: $user');
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        print(e.toString());
      });
    }
  }

  Future<void> _fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Map<String, String>> formattedContacts = contacts.map((contact) {
        String mobileNumber = contact.phones?.isNotEmpty ?? false
            ? contact.phones!.first.value ?? ''
            : '';
        if (mobileNumber.isNotEmpty) {
          mobileNumber = mobileNumber.substring(1);
        }
        return {
          'mobileNumber': mobileNumber,
          'contactName': contact.displayName ?? '',
        };
      }).toList();

      final url = Uri.parse('http://45.126.125.172:8080/api/v1/checkContacts');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formattedContacts),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(response.body) as List<dynamic>;

        final List<Map<String, String>> contactsResponse = responseData
            .where((e) => e['userId'].toString() != widget.userId)
            .map<Map<String, String>>((e) => {
                  'userId': e['userId'].toString(),
                  'contactName': e['contactName'].toString(),
                })
            .toList();

        setState(() {
          users = contactsResponse;
        });
        print('Contacts fetched successfully: $users');
      } else {
        print('Failed to fetch contacts: ${response.statusCode}');
      }
    } else {
      setState(() {
        //_isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. Unable to access contacts.'),
        ),
      );
    }
  }

  Future<void> _createGroup(List<String> ids, String groupName) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create a group with ZIMKit
      String? groupID = await ZIMKit().createGroup(groupName, ids);
      print(groupID);
      print(ids);
      setState(() {
        isLoading = false;
      });

      if (groupID != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ZIMKitMessageListPage(
                conversationID: groupID,
                conversationType: ZIMConversationType.group,
              );
            },
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupMembersPage(groupID: groupID),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create group')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error creating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creating group')),
      );
    }
  }

  void _showCreateGroupModal(BuildContext context) {
    String groupName = '';
    String groupDescription = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(labelText: 'Group Name'),
                    onChanged: (value) {
                      groupName = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      groupDescription = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Next'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showSelectUsersScreen(
                        context, users, groupName, groupDescription);
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSelectUsersScreen(
      BuildContext context,
      List<Map<String, String>> users,
      String groupName,
      String groupDescription) {
    List<String> selectedUsers = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Users'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return CheckboxListTile(
                      title: Text(user['contactName'] ?? ''),
                      subtitle: Text(user['userId'] ?? ''),
                      value: selectedUsers.contains(user['userId']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            selectedUsers.add(user['userId']!);
                          } else {
                            selectedUsers.remove(user['userId']!);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Create'),
                  onPressed: selectedUsers.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _createGroup(selectedUsers, groupName);
                        },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
              const Icon(Icons.search, color: Colors.white),
              PopupMenuButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Chat with id'),
                      onTap: () {
                        ZIMKit().showDefaultNewPeerChatDialog(context);
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('New Chat'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactsScreen(
                                      userId: widget.userId,
                                      Name: widget.name,
                                    )));
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('New Group'),
                      onTap: () {
                        _showCreateGroupModal(context);
                      },
                    ),
                    const PopupMenuItem(child: Text('Linked Devices')),
                    const PopupMenuItem(child: Text('Starred Messages')),
                    const PopupMenuItem(child: Text('Settings')),
                  ];
                },
              ),
            ],
            backgroundColor: const Color(0xff059FDA),
            title: Text('LEO-CHAT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  height: 1.9.h,
                )),
            bottom: state.index == 0
                ? const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        child: Text('CHATS',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Tab(
                        child: Text('STATUS',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Tab(
                        child: Text('CALLS',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    labelColor: Colors.white,
                  )
                : null,
          ),
          body: buildBottomTabs(state.index),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Colors.grey,
            elevation: 1,
            type: BottomNavigationBarType.fixed,
            currentIndex: state.index!,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: (index) {
              context.read<HomePageBloc>().add(IndexEvent(index: index));
            },
            items: [
              BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.chat,
                  color: Colors.blue,
                ),
                icon: Icon(
                  Icons.chat,
                  color: Colors.blue.withOpacity(0.8),
                ),
                label: 'chat',
              ),
              BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.group,
                  color: Colors.blue,
                ),
                icon: Icon(
                  Icons.group,
                  color: Colors.blue.withOpacity(0.8),
                ),
                label: 'group',
              ),
              BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.sports_basketball,
                  color: Colors.blue,
                ),
                icon: Icon(
                  Icons.sports_basketball,
                  color: Colors.blue.withOpacity(0.8),
                ),
                label: 'games',
              ),
              BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                icon: Icon(
                  Icons.person,
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

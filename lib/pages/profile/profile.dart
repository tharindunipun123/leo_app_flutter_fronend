import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {};

  Future<void> readUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user.json');
      final contents = await file.readAsString();
      final data = json.decode(contents);

      setState(() {
        userData = data;
      });
    } catch (e) {
      // Handle any errors here
      print("Error reading user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    readUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: userData.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User ID: ${userData['user_id']}'),
                  Text('Mobile Number: ${userData['mobileNumber']}'),
                  Text('Mobile Number: ${userData['name']}'),
                  Text('Mobile Number: ${userData['about']}'),
                ],
              )
            : const CircularProgressIndicator(), // Show a loading indicator while data is being loaded
      ),
    );
  }
}

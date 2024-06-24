// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:zego_zimkit/zego_zimkit.dart';
// import 'dart:io';
//
//
// import '../home page/home_page.dart';
//
// class UserProfileSetupScreen extends StatefulWidget {
//   const UserProfileSetupScreen({Key? key}) : super(key: key);
//
//   @override
//   _UserProfileSetupScreenState createState() => _UserProfileSetupScreenState();
// }
//
// class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _aboutController = TextEditingController();
//   XFile? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }
//
//   void _saveProfile() async{
//     //if save button clicked , profile photo, userName and User Id send to backEnd   response - userName, pro pic, userId
//
//     await ZIMKit().connectUser(id: '1234', name: 'leo');
//     // Save profile info and navigate to home
//     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MyHomePage()), (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff059FDA),
//         title: const Center(
//             child: Text('Profile Setup',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500
//               ),
//             )),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Center(
//                 child: Text(
//                   'Set up your profile',
//                   style: TextStyle(
//                     fontSize: 19,
//                     color: Colors.black,
//                     height: 1.8,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: _imageFile != null
//                         ? FileImage(File(_imageFile!.path))
//                         : const AssetImage('assets/placeholder.png') as ImageProvider,
//                     child: _imageFile == null
//                         ?  Icon(
//                       Icons.camera_alt,
//                       size: 50,
//                       color: Colors.blue.withOpacity(0.5),
//                     ) : null,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.black26)),
//                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.grey)),
//                   contentPadding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 8.w),
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.w),
//                   ),
//                 ),
//                 onChanged: (userName){
//                   //store and send to backends if clicking save button
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _aboutController,
//                 decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.black26)),
//                   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.grey)),
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
//                   labelText: 'About',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.w),
//                   ),
//                 ),
//                 maxLines: 1,
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xff059FDA),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.w),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                   ),
//                   onPressed: _saveProfile,
//                   child: const Text(
//                     'Save',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../home page/home_page.dart';

class UserProfileSetupScreen extends StatefulWidget {
  final int userId;

  const UserProfileSetupScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileSetupScreenState createState() => _UserProfileSetupScreenState();
}

class _UserProfileSetupScreenState extends State<UserProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _saveProfile() async {
    final name = _nameController.text;
    final about = _aboutController.text;
    final userId = widget.userId;

    Map<String, String> requestBodyData = {
      "userId": userId.toString(),
      "name": name,
      "about": about,
      // Add the image URL or any other necessary data if required
    };

    var jsonData = json.encode(requestBodyData);

    Uri url = Uri.parse('http://192.168.8.157:8080/api/v1/updateProfile');
    final response = await http.post(url, body: jsonData, headers: {'Content-Type': 'application/json'});
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['status'] == 'Profile updated successfully') {
      await ZIMKit().connectUser(id: userId.toString(), name: name);
      // Save profile info and navigate to home
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MyHomePage()), (route) => false);
    } else {
      // Handle profile update failure
      showAlertDialog(context: context, message: 'Profile update failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff059FDA),
        title: const Center(
            child: Text('Profile Setup',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Set up your profile',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : const AssetImage('assets/placeholder.png') as ImageProvider,
                    child: _imageFile == null
                        ? Icon(
                      Icons.camera_alt,
                      size: 50,
                      color: Colors.blue.withOpacity(0.5),
                    ) : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.black26)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.grey)),
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 8.w),
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                ),
                onChanged: (userName){
                  //store and send to backends if clicking save button
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _aboutController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.black26)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.grey)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  labelText: 'About',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff059FDA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: _saveProfile,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertDialog({
  required BuildContext context,
  required String message,
  String? btnText,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 15,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              btnText ?? "OK",
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );
}


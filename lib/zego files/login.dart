import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/home%20page/home_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';


//this page didn't used
class Login extends StatefulWidget{
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? userId;
  String? userName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Login'),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            child: Column(
              children: [
                TextFormField(
                  onChanged: (id){
                    setState(() {
                      userId = id;
                    });
                  },
                  decoration: InputDecoration(
                    label: const Text('User ID'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  ),
                ),
                SizedBox(height: 12.h,),
                TextFormField(
                  onChanged: (name){
                    setState(() {
                      userName = name;
                    });
                  },
                  decoration: InputDecoration(
                    label: const Text('Username'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async{
                        await ZIMKit().connectUser(id: '1234', name: 'leo');
                        Navigator.pushAndRemoveUntil(context ,MaterialPageRoute(builder:(_) => const MyHomePage()), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                    ),
                      child: const Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
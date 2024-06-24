import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/user%20profile%20setup/UserProfileSetupScreen.dart';
import 'package:http/http.dart' as http;

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String sixDigitOtpCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff059FDA),
        title: const Text('Verify Phone Number',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code',
              style: TextStyle(fontSize: 19,
                height: 1.9.h,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.black26)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.w),borderSide: const BorderSide(color: Colors.grey)),
                hintText: '6987',
                labelText: 'OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h)
              ),
              maxLength: 6,
              onChanged: (otpCode){
                sixDigitOtpCode = otpCode;
                //pass wena otp code ekata user dena otp code eka equal nam verify wenna, userId eka pass krnna
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff059FDA),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.w),
                  )
                ),
                onPressed: verifyOtp,
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verifyOtp() async {
    Map<String , String> requestData = {
        "mobileNumber": widget.phoneNumber,
        "otp": sixDigitOtpCode,
    };

    var jsonData = json.encode(requestData);

    Uri url = Uri.parse('http://16.16.27.1:8080/api/v1/verifyOtp');
  //  final response = await http.post(url, body: requestData);

 //   print(response.body);


    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const UserProfileSetupScreen()), (route) => false);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/user%20profile%20setup/UserProfileSetupScreen.dart';
import 'package:leo_final/pages/otp%20verification%20page/OTPVerificationScreen.dart';
import 'package:leo_final/pages/log%20in%20page/log_in_page.dart';
import 'package:leo_final/pages/welcome%20page/welcome_page.dart';
import 'package:leo_final/zego%20files/initial.dart';
import 'package:leo_final/zego%20files/login.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'ChatsTab.dart';
import 'ChatScreen.dart';
import 'LoginScreen.dart';

void main() {
  ZIMKit().init(
      appID: Initial.id,
      appSign: Initial.signIn,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Login(),
        // initialRoute: '/home',
        // onGenerateRoute: (settings) {
        //   switch (settings.name) {
        //     case '/login':
        //       return MaterialPageRoute(builder: (_) => const LoginScreen());
        //     case '/home':
        //       return MaterialPageRoute(builder: (_) => const MyHomePage());
        //     case '/chat':
        //       if (settings.arguments is Map<String, String>) {
        //         final args = settings.arguments as Map<String, String>;
        //         return MaterialPageRoute(
        //           builder: (_) => ChatScreen(
        //             chatTitle: args['chatTitle']!,
        //             imageUrl: args['imageUrl']!,
        //           ),
        //         );
        //       }
        //       return _errorRoute();
        //     default:
        //       return _errorRoute();
        //   }
        // },
      ),
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }
}

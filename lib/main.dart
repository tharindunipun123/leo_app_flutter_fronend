import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/pages/otp_generate_page.dart';
import 'ChatsTab.dart';
import 'ChatScreen.dart';
import 'LoginScreen.dart';

void main() {
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
        home: const OtpGeneratePage(),
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
                  const PopupMenuItem(child: Text('New Group')),
                  const PopupMenuItem(child: Text('New Broadcast')),
                  const PopupMenuItem(child: Text('Linked Devices')),
                  const PopupMenuItem(child: Text('Starred Messages')),
                  const PopupMenuItem(child: Text('Settings')),
                ];
              },
            ),
          ],
          backgroundColor: const Color(0xff059FDA),
          title: const Text('LEO-CHAT', style: TextStyle(color: Colors.white)),
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
        body: const TabBarView(
          children: [
            ChatsTab(),
            Center(child: Text('Status feature is coming soon')),
            Center(child: Text('Call feature is coming soon')),
          ],
        ),
      ),
    );
  }
}

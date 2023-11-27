import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Screens/CallListScreen.dart';
import 'package:chatappyenitasarim/Screens/ChatListScreen.dart';
import 'package:chatappyenitasarim/Screens/SettingsScreen.dart';
import 'package:chatappyenitasarim/Screens/UsersListScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userID = "";
  int activePageIndex = 1;

  Widget activePage = ChatListScreen();
  var subscription;

  @override
  void initState() {
    super.initState();
    if(socket == null) {
      GeneralHelper.connectSocket();
    }
    getUserID();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString("userID")!;
    });
  }

  void changePage(int index) {
    // print(index);
    if(index == 0) {
      setState(() {
        activePageIndex = 0;
        activePage = const CallListScreen();
      });
    }else if(index == 1) {
      setState(() {
        activePageIndex = 1;
        activePage = const ChatListScreen();
      });
    }else if(index == 2) {
      setState(() {
        activePageIndex = 2;
        activePage = const UsersListScreen();
      });
    }
    else if(index == 3) {
      setState(() {
        activePageIndex = 3;
        activePage = const SettingsScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff000e08),
        toolbarHeight: safePadding,
      ),
      body: activePage,
      bottomNavigationBar: SizedBox(
        height: 82,
        child: BottomNavigationBar(
          backgroundColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: activePageIndex,
          onTap: changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.call),
              label: 'Aramalar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Sohbetler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Kişiler',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
}

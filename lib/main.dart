import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Screens/HomeScreen.dart';
import 'package:chatappyenitasarim/Screens/LoginProfileUpdateScreen.dart';
import 'package:chatappyenitasarim/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  await initializeDateFormatting("tr");
  if (pref.getBool("isLoginPermit") == true) {
    if (pref.getBool("isRequiredVerifyPhone") == true) {
      runApp(
        const ProviderScope(
          child: MyApp(
            screen: SplashScreen(),
          ),
        ),
      );
    } else {
      if (pref.getBool("isProfileUpdateRequired") == true) {
        runApp(
          const ProviderScope(
            child: MyApp(
              screen: LoginProfileUpdateScreen(),
            ),
          ),
        );
      } else {
        GeneralHelper.connectSocket();
        runApp(
          const ProviderScope(
            child: MyApp(
              screen: HomeScreen(),
            ),
          ),
        );
      }
    }
  } else {
    runApp(
      const ProviderScope(
        child: MyApp(
          screen: SplashScreen(),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.screen});

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: screen,
    );
  }
}

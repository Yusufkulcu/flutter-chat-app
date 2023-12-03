import 'package:chatappyenitasarim/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff1a1a1a), Color(0xff2a1540), Color(0xff1a1a1a)],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png",width: width * 0.7,),
              SizedBox(
                width: width * 0.7,
                height: height * 0.055,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(const LoginScreen(), transition: Transition.fade);
                  },
                  child: Text("Giriş Yap aa",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

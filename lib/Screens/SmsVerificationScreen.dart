import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Screens/LoginProfileUpdateScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({
    super.key,
    required this.verificationCode,
    required this.userHash,
    required this.userID,
  });

  final String verificationCode;
  final String userHash;
  final String userID;

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {

  late String verificationCode;

  @override
  void initState() {
    super.initState();
    verificationCode = widget.verificationCode;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final safePadding = MediaQuery.of(context).padding.top;
    print(verificationCode);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1a1a1a),
        toolbarHeight: safePadding,
      ),
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
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: width * 0.9,
                child: const Text(
                  "Doğrulama kodunu giriniz",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: width * 0.9,
                child: const Text(
                  "Telefonunuza gönderilen 6 haneli doğrulama kodunu giriniz.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: width * 0.9,
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) async {
                    if(v.length==6) {
                      if(verificationCode == v) {
                        final pref = await SharedPreferences.getInstance();
                        pref.setBool("isRequiredVerifyPhone", false);
                        pref.setBool("isProfileUpdateRequired", true);

                        Get.offAll(const LoginProfileUpdateScreen(),transition: Transition.fade);
                      }else {
                        GeneralHelper.showSnackbarDialog(context, const Text("Hatalı doğrulama kodu"), Colors.red);
                      }
                    }
                  },
                  appContext: context,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

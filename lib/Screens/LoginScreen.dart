import 'dart:convert';

import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Helpers/HttpHelper.dart';
import 'package:chatappyenitasarim/Screens/SmsVerificationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode areaCodeFocus = FocusNode();
  FocusNode phoneNumberFocus = FocusNode();
  PhoneCountryData? areaCodeValue;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    areaCodeFocus.dispose();
    phoneNumberFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a1a),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
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
              const Text(
                "Giriş Yap",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * 0.25,
                    child: CountryDropdown(
                      printCountryName: true,
                      dropdownColor: const Color(0xff2a1540),
                      decoration: const InputDecoration(
                        hintText: "Alan Kodu",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onCountrySelected: (PhoneCountryData countryData) {
                        print(countryData);
                        setState(() {
                          areaCodeValue = countryData;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: width * 0.4,
                    child: TextFormField(
                      controller: phoneNumberController,
                      textAlign: TextAlign.center,
                      focusNode: phoneNumberFocus,
                      style: const TextStyle(color: Colors.white),
                      maxLength: 14,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [MaskedInputFormatter('(###) ###-####')],
                      decoration: const InputDecoration(
                        hintText: "Telefon Numarası",
                        counterText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          FocusScope.of(context).requestFocus(areaCodeFocus);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    width: width * 0.5,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!context.mounted) return;
                        showAdaptiveDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog.adaptive(
                                content: const Text(
                                  "Girdiğin bilgilerin doğruluğundan emin misin ?",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: const Color(0xff2a1540),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Düzelt",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if (phoneNumberController
                                              .value.text.isEmpty ||
                                          areaCodeValue == null ||
                                          phoneNumberController
                                                  .value.text.length !=
                                              14) {
                                        Navigator.of(context).pop();
                                        GeneralHelper.showSnackbarDialog(
                                          context,
                                          const Text(
                                            "Lütfen tüm alanları eksiksiz doldurunuz.",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Colors.red,
                                        );
                                      } else {
                                        final response =
                                            await HttpHelper.loginAction(
                                                areaCodeValue!,
                                                phoneNumberController
                                                    .value.text);
                                        if (response.statusCode == 200) {
                                          final Map<String, dynamic>
                                              responseBody =
                                              jsonDecode(response.body);
                                          print(responseBody);
                                          if (responseBody["status"] ==
                                              "false") {
                                            if (responseBody["responseCode"] ==
                                                "smsaralik") {
                                              GeneralHelper.showSnackbarDialog(
                                                context,
                                                Text(
                                                  responseBody["message"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Colors.red,
                                              );
                                            }
                                          } else if (responseBody["status"] ==
                                              "true") {
                                            final pref = await SharedPreferences
                                                .getInstance();
                                            pref.setBool(
                                                "isRequiredVerifyPhone", true);
                                            pref.setBool("isLoginPermit", true);
                                            pref.setString(
                                                "userHash",
                                                responseBody["userHash"]
                                                    .toString());
                                            pref.setString(
                                                "userID",
                                                responseBody["userID"]
                                                    .toString());
                                            Get.offAll(
                                                SmsVerificationScreen(
                                                  verificationCode:
                                                      responseBody[
                                                          "verificationCode"],
                                                  userHash:
                                                      responseBody["userHash"]
                                                          .toString(),
                                                  userID: responseBody["userID"]
                                                      .toString(),
                                                ),
                                                transition: Transition.fade);
                                          }
                                        } else {
                                          Navigator.of(context).pop();
                                          print(response);
                                          GeneralHelper.showSnackbarDialog(
                                            context,
                                            const Text(
                                              "Sistemsel bir hata oluştu, lütfen daha sonra tekrar deneyiniz.",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Colors.red,
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Evet, eminim",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

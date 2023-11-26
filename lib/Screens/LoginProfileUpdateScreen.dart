import 'dart:convert';
import 'dart:typed_data';

import 'package:chatappyenitasarim/Helpers/GeneralHelper.dart';
import 'package:chatappyenitasarim/Helpers/HttpHelper.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:chatappyenitasarim/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProfileUpdateScreen extends StatefulWidget {
  const LoginProfileUpdateScreen({super.key});

  @override
  State<LoginProfileUpdateScreen> createState() =>
      _LoginProfileUpdateScreenState();
}

class _LoginProfileUpdateScreenState extends State<LoginProfileUpdateScreen> {
  late Future<UserModel> userData;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String name = "";
  String bio = "";
  bool load = false;

  @override
  void initState() {
    super.initState();
    userData = HttpHelper.getUserDataFunction();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final safePadding = MediaQuery.of(context).padding.top;
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
          child: FutureBuilder(
            future: userData,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                // Uint8List base64ProfileImage = Base64Decoder().convert(snapshot.data!.profilePhotoBase64);
                if (load == false) {
                  Future.delayed(Duration.zero, () async {
                    setState(() {
                      load = true;
                      if (name.isNotEmpty) {
                        nameController.text = name;
                      } else {
                        nameController.text = (data.name ?? "");
                      }

                      if (bio.isNotEmpty) {
                        bioController.text = bio;
                      } else {
                        bioController.text = (data.bio ?? "");
                      }
                    });
                  });
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.9,
                      child: const Text(
                        "Profilinizi tamamlayın",
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
                      height: 30,
                    ),
                    SizedBox(
                      width: width * 0.9,
                      child: TextFormField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Gözüken isminiz",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: width * 0.9,
                      child: TextFormField(
                        controller: bioController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Biyografiniz",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onChanged: (value) {
                          setState(() {
                            bio = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: SizedBox(
                          width: width * 0.6,
                          child: ElevatedButton(
                            onPressed: () async {
                              print(nameController.text);
                              print(bioController.text);
                              if (nameController.text.isEmpty ||
                                  bioController.text.isEmpty) {
                                GeneralHelper.showSnackbarDialog(
                                    context,
                                    Text(
                                        "Lütfen tüm alanları eksiksiz doldurunuz."),
                                    Colors.red);
                              }else {
                                  final response = await HttpHelper.updateUser(data.id, {
                                    "name" : nameController.text,
                                    "bio" : bioController.text,
                                    "verifyStatus" : 1
                                  });
                                  if(response == true) {
                                    var pref = await SharedPreferences.getInstance();
                                    pref.setBool("isProfileUpdateRequired", false);
                                    Get.offAll(const HomeScreen(), transition: Transition.fade);
                                  }else {
                                    GeneralHelper.showSnackbarDialog(
                                        context,
                                        Text(
                                            "Sistemsel hata oluştu."),
                                        Colors.red);
                                  }
                              }
                            },
                            child: const Text(
                              "Güncelle ve Giriş Yap",
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
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

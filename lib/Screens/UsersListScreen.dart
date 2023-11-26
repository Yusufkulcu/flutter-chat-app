import 'package:chatappyenitasarim/Helpers/HttpHelper.dart';
import 'package:chatappyenitasarim/Models/UserModel.dart';
import 'package:chatappyenitasarim/Widgets/UserListCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  late Future<List<UserModel>> allUsersFuture;
  String userID = "";
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    getUserID();
    allUsersFuture = HttpHelper.getAllUser();
  }

  Future<void> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString("userID")!;
    });
  }

  void search(String value) async {
    setState(() {
      searchTerm = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: width,
            height: height,
            color: const Color(0xff000e08),
            child: FutureBuilder(
              future: allUsersFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                if (snapshot.hasData) {
                  final allUsers = snapshot.data!;
                  return Column(
                    children: [
                      SizedBox(
                        // color: Colors.amber,
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: SizedBox(
                                    width: width * 0.95,
                                    child: TextFormField(
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                                const BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        hintText: "Kişi ara...",
                                        hintStyle:
                                            const TextStyle(color: Colors.white),
                                        prefixIcon: const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ),
                                        fillColor: Color(0xff201b21),
                                        filled: true,
                                      ),
                                      onChanged: (value) {
                                        search(value);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          width: width,
                          height: height - 220,
                          margin: const EdgeInsets.only(bottom: 155),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final singleUserData = allUsers[index];
                                if(searchTerm.isNotEmpty) {
                                  if(singleUserData.name!.toLowerCase().contains(searchTerm.toLowerCase()) || singleUserData.name!.toLowerCase().contains(searchTerm.toLowerCase())) {
                                    return UserListCardWidget(
                                      userModel: singleUserData,
                                      userID: userID,
                                    );
                                  }else {
                                    return Container();
                                  }
                                }
                                return UserListCardWidget(
                                  userModel: singleUserData,
                                    userID : userID
                                );
                              },
                              itemCount: allUsers.length,
                            ),
                          ),
                        ),
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
      ),
    );
  }
}

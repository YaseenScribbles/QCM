// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/local_db/repository.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/pages/homepage.dart';
import 'package:qcm/pages/login.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool isLoading = true;
  Repository repository = Repository();
  getUserInfo() async {
    List<dynamic> userInfo = await repository.readUserInfo();
    if (userInfo.isNotEmpty) {
      userToken = userInfo[0]['token'];
      userId = userInfo[0]['userid'];
      role = userInfo[0]['role'];
      userName = userInfo[0]['name'];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return const HomePage();
      })));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return const LogIn();
      })));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: isLoading ? const CircularProgressIndicator() : null);
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/login_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/local_db/repository.dart';
import 'package:qcm/pages/homepage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool nameValidation = false;
  bool passwordValidation = false;
  LogInService service = LogInService();
  Repository repository = Repository();
  bool isLoading = false;

  // getLoggedUserInfo() async {
  //   List<Map<String, dynamic>> userInfo = await repository.lastLoggedUserInfo();
  //   if (userInfo.isNotEmpty) {
  //     if (userInfo[0]['email'] != null) {
  //       emailCtrl.text = userInfo[0]['email'];
  //       passwordCtrl.text = userInfo[0]['password'];
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getLoggedUserInfo();
  }

  @override
  void dispose() {
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log In",
          style: kFontAppBar,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Email",
                hintText: "Enter your email",
                errorText: nameValidation ? "Enter valid email" : null,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Password",
                hintText: "Enter your password",
                errorText: passwordValidation ? "Enter valid password" : null,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      emailCtrl.text.isEmpty
                          ? nameValidation = true
                          : nameValidation = false;

                      passwordCtrl.text.isEmpty
                          ? passwordValidation = true
                          : passwordValidation = false;
                    });

                    if (!nameValidation && !passwordValidation) {
                      setState(() {
                        isLoading = true;
                      });
                      var result = await service.login(
                          emailCtrl.text, passwordCtrl.text);

                      setState(() {
                        isLoading = false;
                      });

                      if (result != 'Invalid credentials') {
                        customSnackBar(context, 'Welcome, $userName');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: ((context) {
                          return const HomePage();
                        })));
                      } else {
                        customSnackBar(context, result);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Log In",
                    style: kFontBold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(child: isLoading ? CircularProgressIndicator() : null),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qcm/api/login_service.dart';
import 'package:qcm/api/user_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/pages/login.dart';

class PasswordUpdate extends StatefulWidget {
  const PasswordUpdate({super.key});

  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  final oldPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final confirmPwdCtrl = TextEditingController();
  bool oldPwdValidation = false;
  bool newPwdValidation = false;
  bool confirmPwdValidation = false;
  bool passwordMismatching = false;
  final service = UserService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Update',
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(
        child: kGetDrawer(context),
      ),
      body: isLoading
          ? loadingScreen()
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextFormField(
                      controller: oldPwdCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Old Password',
                          errorText: oldPwdValidation
                              ? 'Old password is not valid'
                              : null),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: newPwdCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'New Password',
                          errorText: newPwdValidation
                              ? 'New password is not valid'
                              : passwordMismatching
                                  ? 'Mismatching Password'
                                  : null),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: confirmPwdCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          errorText: confirmPwdValidation
                              ? 'Confirm password is not valid'
                              : null),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            oldPwdCtrl.text.isEmpty
                                ? oldPwdValidation = true
                                : oldPwdValidation = false;

                            newPwdCtrl.text.isEmpty
                                ? newPwdValidation = true
                                : newPwdValidation = false;

                            confirmPwdCtrl.text.isEmpty
                                ? confirmPwdValidation = true
                                : confirmPwdValidation = false;

                            newPwdCtrl.text.toUpperCase() !=
                                    confirmPwdCtrl.text.toUpperCase()
                                ? passwordMismatching = true
                                : passwordMismatching = false;
                          });

                          if (oldPwdValidation == false &&
                              newPwdValidation == false &&
                              confirmPwdValidation == false &&
                              passwordMismatching == false) {
                            setState(() {
                              isLoading = true;
                            });
                            var result = await service.updatePassword(
                                oldPwdCtrl.text, newPwdCtrl.text);
                            customSnackBar(context, result);
                            setState(() {
                              isLoading = false;
                            });
                            if (result == 'Success') {
                              final logoutService = LogInService();
                              await logoutService.logout();
                              while (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: ((context) {
                                return LogIn();
                              })));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Update',
                          style: kFontBold,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}

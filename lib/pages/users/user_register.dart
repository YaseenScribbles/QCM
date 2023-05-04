import 'package:flutter/material.dart';
import 'package:qcm/api/user_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/user.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final fullNameCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final confirmPwdCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  String department = '';
  bool fullNameValidation = false;
  bool userNameValidation = false;
  bool pwdValidation = false;
  bool confirmPwdValidation = false;
  bool mobileValidation = false;
  bool passwordMismatch = false;
  bool departmentValidation = false;
  bool isLoading = false;
  List<String> departmentList = ['INNER', 'TAQUA', 'VEST'];
  final service = UserService();

  @override
  void dispose() {
    super.dispose();
    fullNameCtrl.dispose();
    userNameCtrl.dispose();
    pwdCtrl.dispose();
    confirmPwdCtrl.dispose();
    mobileCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add User',
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(child: kGetDrawer(context)),
      body: isLoading
          ? loadingScreen()
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        controller: fullNameCtrl,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Full Name',
                            errorText: fullNameValidation
                                ? 'Please enter full name'
                                : null),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Department',
                            errorText: departmentValidation
                                ? 'Select valid department'
                                : null,
                          ),
                          items: departmentList.map((String value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: ((value) {
                            department = value!;
                          })),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: mobileCtrl,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Mobile',
                            errorText: mobileValidation
                                ? 'Please enter valid mobile no'
                                : null),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: userNameCtrl,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'User Name',
                            errorText: userNameValidation
                                ? 'Please enter user name'
                                : null),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: pwdCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            errorText: pwdValidation
                                ? 'Please enter password'
                                : passwordMismatch
                                    ? 'Password mismatch'
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
                                ? 'Please enter user name'
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
                              fullNameCtrl.text.isEmpty
                                  ? fullNameValidation = true
                                  : fullNameValidation = false;

                              departmentList
                                      .where((String value) =>
                                          value.toUpperCase() ==
                                          department.toUpperCase())
                                      .isEmpty
                                  ? departmentValidation = true
                                  : departmentValidation = false;

                              mobileCtrl.text.isEmpty ||
                                      mobileCtrl.text.length != 10
                                  ? mobileValidation = true
                                  : mobileValidation = false;

                              pwdCtrl.text.isEmpty
                                  ? pwdValidation = true
                                  : pwdValidation = false;

                              confirmPwdCtrl.text.isEmpty
                                  ? confirmPwdValidation = true
                                  : confirmPwdValidation = false;

                              pwdCtrl.text.toUpperCase() !=
                                      confirmPwdCtrl.text.toUpperCase()
                                  ? passwordMismatch = true
                                  : passwordMismatch = false;
                            });
                            if (fullNameValidation == false &&
                                mobileValidation == false &&
                                pwdValidation == false &&
                                confirmPwdValidation == false &&
                                passwordMismatch == false) {
                              setState(() {
                                isLoading = true;
                              });
                              final user = User();
                              user.name = fullNameCtrl.text.toUpperCase();
                              user.email = userNameCtrl.text.toUpperCase();
                              user.department = department.toUpperCase();
                              user.phone = mobileCtrl.text;
                              user.password = pwdCtrl.text.toUpperCase();
                              var result = await service.saveUser(user);
                              customSnackBar(context, result);
                              setState(() {
                                isLoading = false;
                              });
                              if (result == 'Success') {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return const UserRegister();
                                })));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'Save',
                            style: kFontBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

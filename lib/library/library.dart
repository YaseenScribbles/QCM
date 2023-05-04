import 'package:flutter/material.dart';
import 'package:qcm/api/login_service.dart';
import 'package:qcm/pages/companies/company_list.dart';
import 'package:qcm/pages/complaints/complaint_list.dart';
import 'package:qcm/pages/homepage.dart';
import 'package:qcm/pages/inspections/inspection_list.dart';
import 'package:qcm/pages/inspections/inspections_search.dart';
import 'package:qcm/pages/login.dart';
import 'package:qcm/pages/lots/lot_search.dart';
import 'package:qcm/pages/segments/segment_list.dart';
import 'package:qcm/pages/suppliers/supplier_list.dart';

// const kURL = 'https://essa.co.in/qcm/api/';
const kURL = 'http://192.168.0.220/qcm/api/';
const kImgURL = 'http://192.168.0.220/qcm/storage/inspections/';
// const kImgURL = 'https://essa.co.in/qcm/storage/inspections/';

String userToken = '';
String userName = '';
String role = '';
int userId = 0;
String imagePath = '';
List<String> imagePaths = [];
List<String> imageURLs = [];

getHeaderWithAuth(String token) {
  Map<String, String> kHeaderWithAuth = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };

  return kHeaderWithAuth;
}

Map<String, String> kHeaderWithoutAuth = {
  'Content-Type': 'application/json',
};

customSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.black,
    duration: const Duration(seconds: 2),
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 15.0,
        fontFamily: 'Poppins',
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ));
}

const kFontAppBar = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
  letterSpacing: 0.5,
);

const kFontBold = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
);

const kIconFont = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
);

const kFontLight = TextStyle(
    fontFamily: 'Poppins', fontWeight: FontWeight.w700, letterSpacing: 0.5);

Future<void> showDialogBox(BuildContext context, String titleText,
    String contentText, String btnText1, String btnText2, Function function1) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            titleText,
            style: kFontBold,
          ),
          content: Text(
            contentText,
            style: kFontBold,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await function1;
              },
              child: Text(
                btnText1,
                style: kFontBold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                btnText2,
                style: kFontBold,
              ),
            ),
          ],
        );
      });
}

Drawer kGetDrawer(BuildContext context) {
  return Drawer(
    child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          height: 200.0,
          color: Colors.blue,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/quality-badge.png',
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.contain,
                ),
                const Text(
                  ' QCM',
                  style: TextStyle(fontSize: 30.0, fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
        ),
        ListTile(
            leading: Icon(Icons.home_outlined),
            title: const Text(
              'Home',
              style: kIconFont,
            ),
            onTap: () {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) {
                return const HomePage();
              })));
            }),
        const Divider(
          color: Colors.white,
        ),
        if (role == 'admin' || role == 'supervisor') ...[
          ListTile(
              leading: Icon(Icons.warehouse_outlined),
              title: const Text(
                'Companies',
                style: kIconFont,
              ),
              onTap: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const CompanyList();
                })));
              }),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
              leading: Icon(Icons.segment_outlined),
              title: const Text(
                'Processes',
                style: kIconFont,
              ),
              onTap: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const SegmentList();
                })));
              }),
          const Divider(
            color: Colors.white,
          ),
          ListTile(
              leading: Icon(Icons.report_problem_outlined),
              title: const Text(
                'Complaints',
                style: kIconFont,
              ),
              onTap: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const ComplaintList();
                })));
              }),
          const Divider(
            color: Colors.white,
          ),
        ],
        ListTile(
            leading: Icon(Icons.safety_check_outlined),
            title: const Text(
              'Inspections',
              style: kIconFont,
            ),
            onTap: () {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return const InspectionList();
              })));
            }),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
            leading: Icon(Icons.search_outlined),
            title: const Text(
              'Inspections Finder',
              style: kIconFont,
            ),
            onTap: () {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return const InspectionsSearch();
              })));
            }),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
            leading: Icon(Icons.search_outlined),
            title: const Text(
              'Job Work Finder',
              style: kIconFont,
            ),
            onTap: () {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return const SupplierList();
              })));
            }),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
            leading: Icon(Icons.search_outlined),
            title: const Text(
              'Lot Finder',
              style: kIconFont,
            ),
            onTap: () {
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return const LotSearch();
              })));
            }),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
            leading: Icon(Icons.logout_outlined),
            title: const Text(
              'Logout',
              style: kIconFont,
            ),
            onTap: () async {
              var service = LogInService();
              var result = await service.logout();
              customSnackBar(context, result);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: ((context) {
                return const LogIn();
              })), (r) => false);
            }),
        const Divider(
          color: Colors.white,
        ),
      ]),
    ),
  );
}

Widget loadingScreen() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

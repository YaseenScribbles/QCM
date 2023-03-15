// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/login_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/pages/companies/company_list.dart';
import 'package:qcm/pages/complaints/complaint_list.dart';
import 'package:qcm/pages/inspections/inspection_list.dart';
import 'package:qcm/pages/inspections/inspections_search.dart';
import 'package:qcm/pages/login.dart';
import 'package:qcm/pages/segments/segment_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LogInService service = LogInService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "HOME PAGE",
          style: kFontAppBar,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await service.logout();
                customSnackBar(context, result);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const LogIn();
                }));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              if (role == 'admin' || role == 'supervisor') ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const CompanyList();
                            }));
                          }),
                          child: const Text(
                            'Companies',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SegmentList();
                            }));
                          }),
                          child: const Text(
                            'Segments',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ComplaintList();
                            }));
                          }),
                          child: const Text(
                            'Complaints',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const InspectionList();
                            }));
                          }),
                          child: const Text(
                            'Inspections',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const InspectionsSearch();
                            }));
                          }),
                          child: const Text(
                            'Inspection Finder',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const InspectionList();
                            }));
                          }),
                          child: const Text(
                            'Inspection',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 120.0,
                        child: ElevatedButton(
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const InspectionsSearch();
                            }));
                          }),
                          child: const Text(
                            'Finder',
                            style: kIconFont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}

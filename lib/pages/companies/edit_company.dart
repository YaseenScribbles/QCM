// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';
import 'package:qcm/pages/companies/company_list.dart';

class EditCompany extends StatefulWidget {
  const EditCompany({super.key, required this.company});
  final Company company;

  @override
  State<EditCompany> createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  bool active = true;
  CompanyService service = CompanyService();

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.company.name.toString();
    active = widget.company.active!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT COMPANY",
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(child: kGetDrawer(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Name",
                    hintText: "Enter company name",
                    errorText: nameValidation ? "Enter valid name" : null),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        nameCtrl.text.isEmpty
                            ? nameValidation = true
                            : nameValidation = false;
                      });

                      if (!nameValidation) {
                        Company company = Company();
                        company.name = nameCtrl.text.toUpperCase();
                        company.id = widget.company.id;
                        company.userId = userId;
                        var result = await service.updateCompany(company);
                        customSnackBar(context, result);
                        if (result == 'Success') {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: ((context) {
                            return const CompanyList();
                          })));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "UPDATE",
                      style: kFontBold,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        active = !active;
                      });
                      Company company = Company();
                      company.id = widget.company.id;
                      company.active = !active;
                      var result =
                          await service.activateAndSuspendCompany(company);
                      customSnackBar(context, result);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    child: active
                        ? const Text(
                            "SUSPEND",
                            style: kFontBold,
                          )
                        : const Text(
                            "ACTIVATE",
                            style: kFontBold,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

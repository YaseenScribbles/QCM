// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  CompanyService service = CompanyService();

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD COMPANY",
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
                    company.userId = userId;
                    var result = await service.saveCompany(company);
                    customSnackBar(context, result);
                    if (result == 'Success') {
                      nameCtrl.clear();
                    }
                  }
                },
                child: const Text(
                  "ADD",
                  style: kFontBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

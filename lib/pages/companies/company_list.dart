import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';
import 'package:qcm/pages/companies/add_company.dart';
import 'package:qcm/pages/companies/edit_company.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({super.key});

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  bool isLoading = true;
  CompanyService service = CompanyService();
  List<Company> companyList = [];
  int count = 0;

  Future getAllCompanies() async {
    companyList = [];
    var companies = await service.getAllCompanies();
    if (companies.isNotEmpty) {
      for (var company in companies) {
        var model = Company();
        model.id = company['id'];
        model.name = company['name'];
        model.userId = int.parse(company['user_id']);
        model.active = int.parse(company['active']) == 1 ? true : false;
        companyList.add(model);
      }
    }
    // print(userToken);
    // print(companies[0]['id']);
    // print(companies[0]['name']);
    // print(companies[0]['active']);
    // print(companies[0]['user_id']);
    // print(companies[0]['id'].runtimeType);
    // print(companies[0]['name'].runtimeType);
    // print(companies[0]['active'].runtimeType);
    // print(companies[0]['user_id'].runtimeType);
    setState(() {
      count = companyList.length;
      isLoading = false;
    });
  }

  Widget emptyCompanies() {
    return const Center(
      child: Text(
        "No companies",
        style: kFontBold,
      ),
    );
  }

  Widget getListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return ListTile(
          shape: Border(
            bottom: BorderSide(),
          ),
          title: Text(
            companyList[index].name.toString(),
            style: kFontBold,
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditCompany(
                company: companyList[index],
              );
            })).then((value) => getAllCompanies());
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAllCompanies,
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              "COMPANIES",
              style: kFontAppBar,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const AddCompany();
                  }))).then((value) => getAllCompanies());
                },
                icon: const Icon(Icons.add_business),
              ),
            ]),
        drawer: SafeArea(child: kGetDrawer(context)),
        body: isLoading
            ? loadingScreen()
            : count == 0
                ? emptyCompanies()
                : getListView(),
      ),
    );
  }
}

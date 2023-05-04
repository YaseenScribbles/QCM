import 'package:flutter/material.dart';
import 'package:qcm/api/supplier_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/supplier.dart';
import 'package:qcm/pages/suppliers/list_by_supplier.dart';

class SupplierList extends StatefulWidget {
  const SupplierList({super.key});

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  final nameCtrl = TextEditingController();
  bool nameValidation = false;
  SupplierService service = SupplierService();
  List<Supplier> supplierList = [];
  int count = 0;
  bool isLoading = false;

  getSearchResults(String name) async {
    setState(() {
      isLoading = true;
    });
    supplierList = [];
    List<dynamic> results = await service.fetchAllByName(name);
    if (results.isNotEmpty) {
      for (var result in results) {
        var model = Supplier();
        model.id = int.parse(result['id']);
        model.name = result['name'];
        supplierList.add(model);
      }
    }
    setState(() {
      count = supplierList.length;
      isLoading = false;
    });
  }

  emptyResults() {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: Text(
            'No Results',
            style: kFontBold,
          ),
        ),
      ),
    );
  }

  getListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: ((context, index) {
        return Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: ListTile(
              title: Text(
                supplierList[index].name.toString(),
                style: kFontBold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              style: ListTileStyle.drawer,
              tileColor: Colors.grey.shade800,
            ),
          );
        });
      }),
    );
  }

  newListView() {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(
              supplierList[index].name.toString(),
              style: kFontBold,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return ListBySupplier(
                  supplier: supplierList[index],
                );
              })));
            },
          );
        }),
        separatorBuilder: ((context, index) {
          return Divider(
            color: Colors.grey.shade600,
          );
        }),
        itemCount: count);
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suppliers',
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(
        child: kGetDrawer(context),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: "Name",
                          errorText: nameValidation ? "Enter valid name" : null,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          setState(() {
                            nameCtrl.text.isEmpty
                                ? nameValidation = true
                                : nameValidation = false;
                          });

                          if (!nameValidation) {
                            getSearchResults(nameCtrl.text);
                          }
                        },
                        child: const Text(
                          "Find",
                          style: kFontBold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                isLoading
                    ? loadingScreen()
                    : count == 0
                        ? emptyResults()
                        : newListView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

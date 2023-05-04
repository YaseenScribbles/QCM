import 'package:flutter/material.dart';
import 'package:qcm/api/supplier_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/making_list.dart';
import 'package:qcm/model/supplier.dart';
import 'package:intl/intl.dart';
import 'package:qcm/pages/inspections/add_inspection.dart';

class ListBySupplier extends StatefulWidget {
  const ListBySupplier({super.key, required this.supplier});
  final Supplier supplier;

  @override
  State<ListBySupplier> createState() => _ListBySupplierState();
}

class _ListBySupplierState extends State<ListBySupplier> {
  final tagNoCtrl = TextEditingController();
  bool tagValidation = false;
  List<MakingList> resultList = [];
  List<MakingList> tempList = [];
  int count = 0;
  bool isLoading = true;
  SupplierService service = SupplierService();

  getSearchResults(int supplierId) async {
    resultList = [];
    tempList = [];
    List<dynamic> results = await service.searchInspection(supplierId);
    if (results.isNotEmpty) {
      for (var result in results) {
        var model = MakingList();
        model.uniqueId = result['unique_id'];
        model.tagNo = result['tag_no'];
        model.deliveryDate = DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(result['delivery_date']));
        model.brand = result['brand'];
        model.style = result['style'];
        model.size = result['size'];
        model.processName = result['process_name'];
        model.supplierName = result['supplier_name'];
        model.ir = result['ir'];
        model.companyId = result['company_id'];
        resultList.add(model);
      }
    }
    tempList = resultList;
    setState(() {
      count = tempList.length;
      isLoading = false;
    });
  }

  getSearchResultsByTagNo(String searchText) {
    tempList = resultList
        .where((element) =>
            element.tagNo!.contains(searchText.toUpperCase()) ||
            element.brand!.contains(searchText.toUpperCase()))
        .toList();

    setState(() {
      count = tempList.length;
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
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return AddInspection(result: tempList[index]);
              })));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        'Tag No : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].tagNo.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Delivery Date : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].deliveryDate.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Brand : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].brand.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Style : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].style.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Size : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].size.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Process : ',
                        style: kFontLight,
                      ),
                      Text(
                        tempList[index].processName.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Supplier : ',
                        style: kFontLight,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    children: [
                      Text(
                        tempList[index].supplierName.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          );
        }),
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey.shade600,
          );
        },
        itemCount: count);
  }

  @override
  void initState() {
    super.initState();
    getSearchResults(widget.supplier.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.supplier.name!,
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(child: kGetDrawer(context)),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      controller: tagNoCtrl,
                      decoration: InputDecoration(
                        labelText: "Tag No / Brand",
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        getSearchResultsByTagNo(value);
                      },
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
                      : getListView(),
            ],
          ),
        )),
      ),
    );
  }
}

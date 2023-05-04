import 'package:flutter/material.dart';
import 'package:qcm/api/inspection_service.dart';
import 'package:qcm/components/my_card.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/making_list.dart';
import 'package:qcm/pages/inspections/add_inspection.dart';

class InspectionsSearch extends StatefulWidget {
  const InspectionsSearch({super.key});

  @override
  State<InspectionsSearch> createState() => _InspectionsSearchState();
}

class _InspectionsSearchState extends State<InspectionsSearch> {
  final tagNoCtrl = TextEditingController();
  bool tagValidation = false;
  InspectionService service = InspectionService();
  List<MakingList> resultList = [];
  int count = 0;
  bool isLoading = false;

  getSearchResults(String tagNo) async {
    setState(() {
      isLoading = true;
    });
    resultList = [];
    List<dynamic> results = await service.searchInspection(tagNo);
    if (results.isNotEmpty) {
      for (var result in results) {
        var model = MakingList();
        model.uniqueId = result['unique_id'];
        model.tagNo = result['tag_no'];
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
    setState(() {
      count = resultList.length;
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 1.0),
          child: MyCard(
            supplierName: resultList[index].supplierName.toString(),
            brandName: resultList[index].brand.toString(),
            processName: resultList[index].processName.toString(),
            tagNo: resultList[index].tagNo.toString(),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return AddInspection(result: resultList[index]);
              })));
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tagNoCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inspections Finder",
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(child: kGetDrawer(context)),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      controller: tagNoCtrl,
                      decoration: InputDecoration(
                        hintText: "Tag No",
                        errorText: tagValidation ? "Enter valid tag no" : null,
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
                          tagNoCtrl.text.isEmpty
                              ? tagValidation = true
                              : tagValidation = false;
                        });

                        if (!tagValidation) {
                          getSearchResults(tagNoCtrl.text);
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
        )),
      ),
    );
  }
}

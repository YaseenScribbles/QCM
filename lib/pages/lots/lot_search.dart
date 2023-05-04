import 'package:flutter/material.dart';
import 'package:qcm/api/lot_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/lot.dart';
import 'package:qcm/pages/lots/add_inspection_by_lot.dart';

class LotSearch extends StatefulWidget {
  const LotSearch({super.key});

  @override
  State<LotSearch> createState() => _LotSearchState();
}

class _LotSearchState extends State<LotSearch> {
  final nameCtrl = TextEditingController();
  bool nameValidation = false;
  bool isLoading = false;
  int count = 0;
  List<Lot> lotList = [];
  final service = LotService();

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

  newListView() {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                return AddInspectionByLot(result: lotList[index]);
              })));
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      Text(
                        'Lot No : ',
                        style: kFontLight,
                      ),
                      Text(
                        lotList[index].lotNo.toString(),
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
                        lotList[index].brand.toString(),
                        style: kFontLight,
                      ),
                    ],
                  ),
                  if (lotList[index].merchandizer.toString() != '') ...[
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      children: [
                        Text(
                          'Merch : ',
                          style: kFontLight,
                        ),
                        Text(
                          lotList[index].merchandizer.toString(),
                          style: kFontLight,
                        ),
                      ],
                    ),
                  ],
                ]),
              ),
            ),
          );
        }),
        separatorBuilder: ((context, index) {
          return Divider(
            color: Colors.grey.shade600,
          );
        }),
        itemCount: count);
  }

  getSearchResults(String lotNo) async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> results = await service.fetchByLotNo(lotNo);
    lotList = [];
    if (results.isNotEmpty) {
      for (var result in results) {
        var model = Lot();
        model.lotId = result['lot_id'];
        model.lotNo = result['lot_no'];
        model.brand = result['brand'];
        model.merchandizer = result['merchandizer'] ?? '';
        model.companyId = int.parse(result['company_id']);
        lotList.add(model);
      }
    }
    setState(() {
      count = lotList.length;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lot Finder',
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

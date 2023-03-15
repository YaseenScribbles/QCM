// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/api/inspection_service.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/model/inspection.dart';
import 'package:qcm/model/making_list.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/inspections/inspection_list.dart';

class AddInspection extends StatefulWidget {
  const AddInspection({super.key, required this.result});
  final MakingList result;

  @override
  State<AddInspection> createState() => _AddInspectionState();
}

class _AddInspectionState extends State<AddInspection> {
  final remarksCtrl = TextEditingController();
  final tagNoCtrl = TextEditingController();
  final processNameCtrl = TextEditingController();
  final sectionCtrl = TextEditingController();
  final brandCtrl = TextEditingController();
  final styleCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  bool isLoading = true;
  int segmentId = 0;
  int companyId = 0;
  int complaintId = 0;
  bool segmentValidation = false;
  bool complaintValidation = false;
  // bool companyValidation = false;
  // bool remarksValdiation = false;
  List<Segment> segmentList = [];
  List<Company> companyList = [];
  List<Complaint> tempComplaintList = [];
  List<Complaint> complaintList = [];
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final segmentService = SegmentService();
  final companyService = CompanyService();
  final complaintService = ComplaintService();
  final service = InspectionService();

  updateComplaintList() {
    setState(() {
      tempComplaintList = complaintList
          .where((element) => element.segmentId == segmentId)
          .toList();
    });
  }

  getListsForDropDown() async {
    segmentList = [];

    var segments = await segmentService.getAllSegments();
    if (segments.isNotEmpty) {
      for (var segment in segments) {
        var model = Segment();
        model.id = segment['id'];
        model.name = segment['name'];
        model.active = int.parse(segment['active']) == 1 ? true : false;
        model.userId = int.parse(segment['user_id']);
        segmentList.add(model);
      }
    }

    companyList = [];
    var companies = await companyService.getAllCompanies();
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

    complaintList = [];
    List<dynamic> complaints = await complaintService.getAllComplaints();
    if (complaints.isNotEmpty) {
      for (var complaint in complaints) {
        var model = Complaint();
        model.id = complaint['id'];
        model.name = complaint['name'];
        model.segmentId = int.parse(complaint['segment_id']);
        model.segmentName = complaint['segment_name'];
        complaintList.add(model);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  reset() {
    _key.currentState!.reset();
  }

  saveInspection(BuildContext context) async {
    setState(() {
      segmentId < 1 ? segmentValidation = true : segmentValidation = false;

      complaintId < 1
          ? complaintValidation = true
          : complaintValidation = false;

      // remarksCtrl.text.isEmpty
      //     ? remarksValdiation = true
      //     : remarksValdiation = false;

      // companyId < 1 ? companyValidation = true : companyValidation = false;
    });

    if (!segmentValidation && !complaintValidation) {
      final inspection = Inspection();
      inspection.uniqueId = widget.result.uniqueId;
      inspection.segmentId = segmentId;
      inspection.complaintId = complaintId;
      inspection.remarks = remarksCtrl.text;
      inspection.companyId = int.parse(widget.result.companyId!);
      inspection.userId = userId;
      var result = await service.saveInspection(inspection);
      customSnackBar(context, result);
      if (result == 'Success') {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const InspectionList();
        })));
      }
    }
  }

  loadForm() {
    return SingleChildScrollView(
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
        child: Column(children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  readOnly: true,
                  controller: tagNoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Tag No",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: TextField(
                  readOnly: true,
                  controller: processNameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Process",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            readOnly: true,
            controller: sectionCtrl,
            decoration: const InputDecoration(
              labelText: "Section",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  controller: brandCtrl,
                  decoration: const InputDecoration(
                    labelText: "Brand",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  controller: styleCtrl,
                  decoration: const InputDecoration(
                    labelText: "Style",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                flex: 1,
                child: TextField(
                  readOnly: true,
                  controller: sizeCtrl,
                  decoration: const InputDecoration(
                    labelText: "Size ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Segment",
              errorText: segmentValidation ? "Select valid segment" : null,
            ),
            items: segmentList.map((e) {
              return DropdownMenuItem(
                value: e.id!,
                child: Text(
                  e.name.toString(),
                  style: kFontBold,
                ),
              );
            }).toList(),
            onChanged: ((value) {
              segmentId = value!;
              reset();
              updateComplaintList();
            }),
          ),
          const SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField(
            key: _key,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "Complaint",
              errorText: complaintValidation ? "Select valid complaint" : null,
            ),
            items: tempComplaintList.isNotEmpty
                ? tempComplaintList.map((e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(
                        e.name.toString(),
                        style: kFontBold,
                      ),
                    );
                  }).toList()
                : null,
            onChanged: ((value) {
              complaintId = value!;
            }),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: remarksCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Remarks",
              // errorText: remarksValdiation ? "Enter Remarks" : null,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          // DropdownButtonFormField(
          //   decoration: InputDecoration(
          //     border: const OutlineInputBorder(),
          //     hintText: "Company",
          //     errorText: companyValidation ? "Select valid company" : null,
          //   ),
          //   value: companyId,
          //   items: companyList.map((e) {
          //     return DropdownMenuItem(
          //       value: e.id,
          //       child: Text(
          //         e.name.toString(),
          //         style: kFontBold,
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: ((value) {
          //     companyId = value!;
          //   }),
          // ),
          // const SizedBox(
          //   height: 20.0,
          // ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await saveInspection(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Save',
                style: kFontBold,
              ),
            ),
          )
        ]),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    getListsForDropDown();
    tagNoCtrl.text = widget.result.tagNo!;
    processNameCtrl.text = widget.result.processName!;
    sectionCtrl.text = widget.result.supplierName!;
    brandCtrl.text = widget.result.brand!;
    styleCtrl.text = widget.result.style!;
    sizeCtrl.text = widget.result.size!;
  }

  @override
  void dispose() {
    super.dispose();
    remarksCtrl.dispose();
    tagNoCtrl.dispose();
    processNameCtrl.dispose();
    sectionCtrl.dispose();
    brandCtrl.dispose();
    styleCtrl.dispose();
    sizeCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Inspection",
          style: kFontAppBar,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await saveInspection(context);
              },
              icon: Icon(Icons.save_outlined))
        ],
      ),
      drawer: SafeArea(
        child: kGetDrawer(context),
      ),
      body: isLoading ? loadingScreen() : loadForm(),
    );
  }
}

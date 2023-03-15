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

class EditInspection extends StatefulWidget {
  const EditInspection(
      {super.key, required this.inspection, required this.result});
  final Inspection inspection;
  final MakingList result;

  @override
  State<EditInspection> createState() => _EditInspectionState();
}

class _EditInspectionState extends State<EditInspection> {
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
  bool dateValidation = false;
  List<Segment> segmentList = [];
  List<Company> companyList = [];
  List<Complaint> tempComplaintList = [];
  List<Complaint> complaintList = [];
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final segmentService = SegmentService();
  final companyService = CompanyService();
  final complaintService = ComplaintService();
  final service = InspectionService();

  updateComplaintList(int value) {
    setState(() {
      tempComplaintList =
          complaintList.where((element) => element.segmentId == value).toList();
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
      tempComplaintList = complaintList;
    });

    updateComplaintList(widget.inspection.segmentId!);
  }

  reset() {
    _key.currentState!.reset();
  }

  updateInspection(BuildContext context) async {
    setState(() {
      segmentId < 1 ? segmentValidation = true : segmentValidation = false;

      complaintId < 1
          ? complaintValidation = true
          : complaintValidation = false;

      // remarksCtrl.text.isEmpty
      //     ? remarksValdiation = true
      //     : remarksValdiation = false;

      // companyId < 1
      //     ? companyValidation = true
      //     : companyValidation = false;
    });

    if (!segmentValidation && !complaintValidation) {
      final inspection = Inspection();
      inspection.id = widget.inspection.id;
      inspection.uniqueId = widget.result.uniqueId;
      inspection.segmentId = segmentId;
      inspection.complaintId = complaintId;
      inspection.remarks = remarksCtrl.text;
      inspection.companyId = int.parse(widget.result.companyId!);
      inspection.userId = userId;
      var result = await service.updateInspection(inspection);
      customSnackBar(context, result);
      if (result == 'Success') {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const InspectionList();
        })));
      }
    }
  }

  deleteInspection() async {
    var inspection = Inspection();
    inspection.id = widget.inspection.id;
    var result = await service.deleteInspection(inspection);
    customSnackBar(context, result);
    if (result == 'Success') {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return const InspectionList();
      })));
    }
  }

  loadForm() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 10.0),
          child: Column(
            children: [
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
                value: segmentId,
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
                  complaintId = 0;
                  updateComplaintList(value);
                }),
              ),
              const SizedBox(
                height: 20.0,
              ),
              DropdownButtonFormField(
                value: complaintId != 0 ? complaintId : null,
                key: _key,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Complaint",
                  errorText:
                      complaintValidation ? "Select valid complaint" : null,
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
                    await updateInspection(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Update',
                    style: kFontBold,
                  ),
                ),
              ),
              if (role == 'supervisor' || role == 'admin') ...[
                const SizedBox(
                  height: 5.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Delete',
                                style: kFontBold,
                              ),
                              content: Text(
                                'Are you sure ?',
                                style: kFontBold,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await deleteInspection();
                                  },
                                  child: Text(
                                    'Ok',
                                    style: kFontBold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: kFontBold,
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Delete',
                      style: kFontBold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getListsForDropDown();
    segmentId = widget.inspection.segmentId!;
    complaintId = widget.inspection.complaintId!;
    remarksCtrl.text = widget.inspection.remarks ?? '';
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
          "Edit Inspection",
          style: kFontAppBar,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await updateInspection(context);
            },
            icon: const Icon(Icons.save_outlined),
          )
        ],
      ),
      drawer: SafeArea(
        child: kGetDrawer(context),
      ),
      body: isLoading ? loadingScreen() : loadForm(),
    );
  }
}

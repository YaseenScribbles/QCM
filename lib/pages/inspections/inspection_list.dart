// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/api/inspection_service.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/model/inspection.dart';
import 'package:date_field/date_field.dart';
import 'package:qcm/model/making_list.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/inspections/edit_inspection.dart';
import 'package:intl/intl.dart';

class InspectionList extends StatefulWidget {
  const InspectionList({super.key});

  @override
  State<InspectionList> createState() => _InspectionListState();
}

class _InspectionListState extends State<InspectionList> {
  bool isLoading = true;
  int count = 0;
  List<Inspection> inspectionList = [];
  List<MakingList> makingList = [];
  List<Segment> segmentList = [];
  List<Complaint> complaintList = [];
  List<Company> companyList = [];
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  InspectionService service = InspectionService();
  SegmentService segmentService = SegmentService();
  ComplaintService complaintService = ComplaintService();
  CompanyService companyService = CompanyService();

  DateTime selectedDate = DateTime.now();

  getLists() async {
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
  }

  String getSegmentName(int id) {
    List<Segment> tempList = [];
    String name = '';
    tempList = segmentList.where((element) => element.id == id).toList();
    name = tempList[0].name!;
    return name;
  }

  String getComplaintName(int id) {
    List<Complaint> tempList = [];
    String name = '';
    tempList = complaintList.where((element) => element.id == id).toList();
    name = tempList[0].name!;
    return name;
  }

  String getCompanyName(int id) {
    List<Company> tempList = [];
    String name = '';
    tempList = companyList.where((element) => element.id == id).toList();
    name = tempList[0].name!;
    return name;
  }

  getInspections(DateTime date) async {
    setState(() {
      isLoading = true;
    });
    await getLists();
    inspectionList = [];
    List<dynamic> inspections = await service.getAll(date);
    if (inspections.isNotEmpty) {
      for (var inspection in inspections) {
        var model = Inspection();
        var result = MakingList();
        model.id = inspection['id'];
        model.uniqueId = inspection['unique_id'];
        model.segmentId = int.parse(inspection['segment_id']);
        model.complaintId = int.parse(inspection['complaint_id']);
        model.remarks = inspection['remarks'];
        model.companyId = int.parse(inspection['company_id']);
        model.userId = int.parse(inspection['user_id']);
        model.createdAt = DateTime.parse(inspection['created_at']);
        result.uniqueId = inspection['making']['unique_id'];
        result.supplierName = inspection['making']['supplier_name'];
        result.brand = inspection['making']['brand'];
        result.tagNo = inspection['making']['tag_no'];
        result.style = inspection['making']['style'];
        result.size = inspection['making']['size'];
        result.processName = inspection['making']['process_name'];
        result.companyId = inspection['making']['company_id'];
        result.ir = inspection['making']['ir'];
        inspectionList.add(model);
        makingList.add(result);
      }
    }
    setState(() {
      count = inspectionList.length;
      isLoading = false;
    });
  }

  emptyInspections() {
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: Text(
              'No Inspections',
              style: kFontBold,
            ),
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
          return GestureDetector(
            onTap: () {
              var date = DateTime.parse(
                  dateFormat.format(inspectionList[index].createdAt!));
              var currentDate = DateTime.now();
              if (DateUtils.isSameDay(currentDate, date)) {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return EditInspection(
                      inspection: inspectionList[index],
                      result: makingList[index]);
                })));
              } else {
                customSnackBar(context, 'Access denied');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 10.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Section :',
                        style: kFontBold,
                      ),
                      Text(
                        makingList[index].supplierName.toString(),
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Process : ${makingList[index].processName}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Tag No : ${makingList[index].tagNo}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Brand : ${makingList[index].brand}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Style : ${makingList[index].style}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Size : ${makingList[index].size}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Segment : ${getSegmentName(inspectionList[index].segmentId!)}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Complaint : ${getComplaintName(inspectionList[index].complaintId!)}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (inspectionList[index].remarks.toString() !=
                          'null') ...[
                        const Text(
                          'Remarks :',
                          style: kFontBold,
                        ),
                        Text(
                          inspectionList[index].remarks.toString(),
                          style: kFontBold,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  loading() {
    return const Center(child: CircularProgressIndicator());
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2001, 1),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getInspections(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "INSPECTIONS",
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
                children: [
                  Flexible(
                    flex: 2,
                    child: DateTimeFormField(
                      initialValue: DateTime.now(),
                      decoration: const InputDecoration(
                        hintText: "Pick a date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      onDateSelected: (value) {
                        selectedDate = value;
                      },
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
                      onPressed: () async {
                        await getInspections(selectedDate);
                      },
                      child: const Text(
                        "Search",
                        style: kFontBold,
                        softWrap: false,
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
                      ? emptyInspections()
                      : getListView(),
            ],
          ),
        )),
      ),
    );
  }
}

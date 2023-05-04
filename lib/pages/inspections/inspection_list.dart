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
import 'package:qcm/model/lot.dart';
import 'package:qcm/model/making_list.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/inspections/edit_inspection.dart';
import 'package:intl/intl.dart';
import 'package:qcm/pages/lots/edit_inspection_by_lot.dart';

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
  List<Lot> lotList = [];
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
        var lot = Lot();
        model.id = int.parse(inspection['id']);
        model.uniqueId = inspection['unique_id'];
        model.segmentId = int.parse(inspection['segment_id']);
        model.complaintId = int.parse(inspection['complaint_id']);
        model.remarks = inspection['remarks'];
        model.companyId = int.parse(inspection['company_id']);
        model.isJobWork = int.parse(inspection['is_jobwork']);
        model.userId = int.parse(inspection['user_id']);
        model.createdAt = DateTime.parse(inspection['created_at']);
        inspectionList.add(model);

        if (inspection['tag_no'].toString() != 'null') {
          result.uniqueId = inspection['unique_id'];
          result.supplierName = inspection['supplier_name'];
          result.brand = inspection['brand'];
          result.tagNo = inspection['tag_no'];
          result.style = inspection['style'];
          result.size = inspection['size'];
          result.processName = inspection['process_name'];
          result.companyId = inspection['company_id'];
          result.ir = inspection['ir'];
          makingList.add(result);
        }

        if (inspection['lot_id'].toString() != 'null') {
          lot.lotId = inspection['lot_id'];
          lot.lotNo = inspection['lot_no'];
          lot.brand = inspection['lot_brand'];
          lot.merchandizer = inspection['merchandizer'];
          lot.companyId = int.parse(inspection['company_id']);
          lotList.add(lot);
        }
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

  int getLotListIndex(String lotId) {
    return lotList.indexWhere((element) => element.lotId == lotId);
  }

  int getMakingListIndex(String uniqueId) {
    return makingList.indexWhere((element) => element.uniqueId == uniqueId);
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
                inspectionList[index].isJobWork == 0
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                        return EditInspectionByLot(
                            inspection: inspectionList[index],
                            result: lotList[getLotListIndex(
                                inspectionList[index].uniqueId!)]);
                      })))
                    : Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                        return EditInspection(
                            inspection: inspectionList[index],
                            result: makingList[getMakingListIndex(
                                inspectionList[index].uniqueId!)]);
                      })));
              } else {
                customSnackBar(context, 'Access denied');
              }
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (inspectionList[index].isJobWork == 1) ...[
                      const Text(
                        'Section :',
                        style: kFontBold,
                      ),
                      Text(
                        makingList[getMakingListIndex(
                                inspectionList[index].uniqueId!)]
                            .supplierName
                            .toString(),
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Process : ${makingList[getMakingListIndex(inspectionList[index].uniqueId!)].processName}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Tag No : ${makingList[getMakingListIndex(inspectionList[index].uniqueId!)].tagNo}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Brand : ${makingList[getMakingListIndex(inspectionList[index].uniqueId!)].brand}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Style : ${makingList[getMakingListIndex(inspectionList[index].uniqueId!)].style}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Size : ${makingList[getMakingListIndex(inspectionList[index].uniqueId!)].size}',
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
                    ] else if (inspectionList[index].isJobWork == 0) ...[
                      Text(
                        'Lot No : ${lotList[getLotListIndex(inspectionList[index].uniqueId!)].lotNo.toString()}',
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'Brand :',
                        style: kFontBold,
                      ),
                      Text(
                        lotList[getLotListIndex(
                                inspectionList[index].uniqueId!)]
                            .brand
                            .toString(),
                        style: kFontBold,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Merch : ${lotList[getLotListIndex(inspectionList[index].uniqueId!)].merchandizer.toString()}',
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
                  ],
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
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 0.0),
              child: Row(
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
            ),
            const SizedBox(
              height: 14.0,
            ),
            isLoading
                ? loadingScreen()
                : count == 0
                    ? emptyInspections()
                    : getListView(),
          ],
        )),
      ),
    );
  }
}

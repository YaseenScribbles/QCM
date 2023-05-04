import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qcm/api/company_service.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/api/inspection_service.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/model/inspection.dart';
import 'package:qcm/model/lot.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/inspections/display_picture.dart';
import 'package:qcm/pages/inspections/inspection_list.dart';
import 'package:qcm/pages/inspections/take_picture.dart';

class AddInspectionByLot extends StatefulWidget {
  const AddInspectionByLot({super.key, required this.result});
  final Lot result;
  @override
  State<AddInspectionByLot> createState() => _AddInspectionByLotState();
}

class _AddInspectionByLotState extends State<AddInspectionByLot> {
  bool isLoading = true;
  final lotNoCtrl = TextEditingController();
  final brandCtrl = TextEditingController();
  final merchCtrl = TextEditingController();
  final remarksCtrl = TextEditingController();
  int segmentId = 0;
  int companyId = 0;
  int complaintId = 0;
  bool segmentValidation = false;
  bool complaintValidation = false;
  List<Segment> segmentList = [];
  List<Company> companyList = [];
  List<Complaint> tempComplaintList = [];
  List<Complaint> complaintList = [];
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final segmentService = SegmentService();
  final companyService = CompanyService();
  final complaintService = ComplaintService();
  final service = InspectionService();
  late CameraDescription cameraDescription;
  late XFile image;
  int imagePathCount = 0;

  getCamera() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    cameraDescription = cameras.first;
  }

  updateImage(String path) {
    setState(() {
      imagePath = path;
    });
  }

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
      setState(() {
        isLoading = true;
      });
      final inspection = Inspection();
      inspection.uniqueId = widget.result.lotId;
      inspection.segmentId = segmentId;
      inspection.complaintId = complaintId;
      inspection.remarks = remarksCtrl.text;
      inspection.companyId = widget.result.companyId!;
      inspection.isJobWork = 0;
      inspection.userId = userId;
      var result = await service.saveInspection(inspection);
      if (imagePaths.isNotEmpty && result != 'Failed') {
        await service.savePicture(result);
      }

      if (result != 'Failed') {
        imagePaths = [];
        customSnackBar(context, 'Success');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) {
          return const InspectionList();
        })));
      } else {
        customSnackBar(context, 'Failed');
      }

      setState(() {
        isLoading = false;
        imagePathCount = imagePaths.length;
      });
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
                  controller: lotNoCtrl,
                  decoration: const InputDecoration(
                    labelText: "Lot No",
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
                  controller: merchCtrl,
                  decoration: const InputDecoration(
                    labelText: "Merch",
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
            controller: brandCtrl,
            decoration: const InputDecoration(
              labelText: "Brand",
              border: OutlineInputBorder(),
            ),
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
          if (imagePathCount > 0) ...[
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: 200.0,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                itemCount: imagePathCount,
                itemBuilder: ((context, index) {
                  return Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return DisplayPictureScreen(
                                imagePath: imagePaths[index]);
                          })));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          height: 200.0,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.file(
                            File(imagePaths[index]),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              imagePaths.removeAt(index);
                              setState(() {
                                imagePathCount = imagePaths.length;
                              });
                            },
                            child: Container(
                              child: Icon(Icons.close_outlined),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () async {
                  await getCamera();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return TakePictureScreen(camera: cameraDescription);
                  }))).then((value) {
                    setState(() {
                      imagePathCount = imagePaths.length;
                    });
                  });
                },
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
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
    lotNoCtrl.text = widget.result.lotNo!;
    merchCtrl.text = widget.result.merchandizer!;
    brandCtrl.text = widget.result.brand!;
  }

  @override
  void dispose() {
    super.dispose();
    brandCtrl.dispose();
    lotNoCtrl.dispose();
    merchCtrl.dispose();
    remarksCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Inspection',
          style: kFontAppBar,
        ),
      ),
      body: isLoading ? loadingScreen() : loadForm(),
    );
  }
}

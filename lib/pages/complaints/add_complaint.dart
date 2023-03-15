// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/complaints/complaint_list.dart';
import 'package:qcm/pages/segments/add_segment.dart';

class AddComplaint extends StatefulWidget {
  const AddComplaint({super.key});

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  bool isLoading = true;
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  bool segmentValidation = false;
  int segmentId = 0;
  List<Segment> segmentList = [];
  SegmentService segmentService = SegmentService();
  ComplaintService service = ComplaintService();

  getAllSegments() async {
    segmentList = [];
    List<dynamic> segments = await segmentService.getAllSegments();
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
    setState(() {
      isLoading = false;
    });
  }

  loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllSegments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD COMPLAINT",
          style: kFontAppBar,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const AddSegment();
                }))).then((value) => getAllSegments());
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: SafeArea(
        child: kGetDrawer(context),
      ),
      body: isLoading
          ? loading()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      value: segmentId == 0 ? null : segmentId,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Segment",
                        hintText: "Select a segment",
                        errorText:
                            segmentValidation ? "Select valid segment" : null,
                      ),
                      items: segmentList.map((segment) {
                        return DropdownMenuItem(
                          value: segment.id,
                          child: Text(segment.name.toString()),
                        );
                      }).toList(),
                      onChanged: ((value) {
                        setState(() {
                          segmentId = value!;
                        });
                      }),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Name",
                        hintText: "Enter complaint name",
                        errorText: nameValidation ? "Enter valid name" : null,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          nameCtrl.text.isEmpty
                              ? nameValidation = true
                              : nameValidation = false;

                          segmentId < 1
                              ? segmentValidation = true
                              : segmentValidation = false;
                        });

                        if (!nameValidation && !segmentValidation) {
                          Complaint complaint = Complaint();
                          complaint.name = nameCtrl.text;
                          complaint.segmentId = segmentId;
                          complaint.userId = userId;
                          var result = await service.saveComplaint(complaint);
                          customSnackBar(context, result);
                          if (result == 'Success') {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const ComplaintList();
                            }));
                          }
                        }
                      },
                      child: const Text(
                        "SAVE",
                        style: kFontBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

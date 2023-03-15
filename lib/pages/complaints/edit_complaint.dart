// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/complaints/complaint_list.dart';
import 'package:qcm/pages/segments/add_segment.dart';

class EditComplaint extends StatefulWidget {
  const EditComplaint({super.key, required this.complaint});
  final Complaint complaint;
  @override
  State<EditComplaint> createState() => _EditComplaintState();
}

class _EditComplaintState extends State<EditComplaint> {
  bool isLoading = true;
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  bool segmentValidation = false;
  bool active = true;
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

  getComplaint() async {
    var tempComplaint = await service.getComplaint(widget.complaint.id!);
    active = int.parse(tempComplaint['active']) == 1 ? true : false;
  }

  @override
  void initState() {
    super.initState();
    getComplaint();
    getAllSegments();
    segmentId = widget.complaint.segmentId!;
    nameCtrl.text = widget.complaint.name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT COMPLAINT",
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Segment",
                        hintText: "Select a segment",
                        errorText:
                            segmentValidation ? "Select valid segment" : null,
                      ),
                      items: segmentList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name!),
                            ),
                          )
                          .toList(),
                      onChanged: ((value) {
                        setState(() {
                          segmentId = value!;
                        });
                      }),
                      value: segmentId == 0 ? null : segmentId,
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
                    Row(
                      children: [
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
                              complaint.id = widget.complaint.id;
                              complaint.name = nameCtrl.text;
                              complaint.segmentId = segmentId;
                              complaint.userId = userId;
                              var result =
                                  await service.updateComplaint(complaint);
                              customSnackBar(context, result);
                              if (result == 'Success') {
                                Navigator.pop(context);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ComplaintList();
                                }));
                              }
                            }
                          },
                          child: const Text(
                            "UPDATE",
                            style: kFontBold,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              active = !active;
                            });
                            Complaint complaint = Complaint();
                            complaint.id = widget.complaint.id;
                            complaint.active = !active;
                            var result = await service
                                .activateAndSuspendComplaint(complaint);
                            customSnackBar(context, result);
                          },
                          child: active
                              ? const Text(
                                  "SUSPEND",
                                  style: kFontBold,
                                )
                              : const Text(
                                  "ACTIVATE",
                                  style: kFontBold,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

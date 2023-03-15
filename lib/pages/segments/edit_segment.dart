// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/segments/segment_list.dart';

class EditSegment extends StatefulWidget {
  const EditSegment({super.key, required this.segment});
  final Segment segment;
  @override
  State<EditSegment> createState() => _EditSegmentState();
}

class _EditSegmentState extends State<EditSegment> {
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  bool active = true;
  SegmentService service = SegmentService();

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.segment.name.toString();
    active = widget.segment.active!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EDIT SEGMENT",
          style: kFontAppBar,
        ),
      ),
      drawer: SafeArea(child: kGetDrawer(context)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Name",
                    hintText: "Enter segment name",
                    errorText: nameValidation ? "Enter valid name" : null),
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
                      });

                      if (!nameValidation) {
                        Segment segment = Segment();
                        segment.name = nameCtrl.text.toUpperCase();
                        segment.id = widget.segment.id;
                        segment.userId = userId;
                        var result = await service.updateSegment(segment);
                        customSnackBar(context, result);
                        if (result == 'Success') {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: ((context) {
                            return const SegmentList();
                          })));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
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
                      Segment segment = Segment();
                      segment.id = widget.segment.id;
                      segment.active = !active;
                      var result =
                          await service.activateAndSuspendSegment(segment);
                      customSnackBar(context, result);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
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

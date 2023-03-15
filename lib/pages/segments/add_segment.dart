// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/segment.dart';

class AddSegment extends StatefulWidget {
  const AddSegment({super.key});

  @override
  State<AddSegment> createState() => _AddSegmentState();
}

class _AddSegmentState extends State<AddSegment> {
  TextEditingController nameCtrl = TextEditingController();
  bool nameValidation = false;
  SegmentService service = SegmentService();

  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ADD SEGMENT",
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
                    segment.userId = userId;
                    var result = await service.saveSegment(segment);
                    customSnackBar(context, result);
                    if (result == 'Success') {
                      nameCtrl.clear();
                    }
                  }
                },
                child: const Text(
                  "ADD",
                  style: kFontBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qcm/library/library.dart';

class MyCard extends StatelessWidget {
  const MyCard(
      {super.key,
      required this.supplierName,
      required this.brandName,
      required this.processName,
      required this.tagNo,
      required this.onTap});

  final String supplierName;
  final String brandName;
  final String processName;
  final String tagNo;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          shape: BoxShape.rectangle,
          color: Colors.grey.shade800,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Section :',
              style: kFontBold,
            ),
            Text(
              supplierName,
              style: kFontBold,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Brand : $brandName',
              style: kFontBold,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Process : $processName',
              style: kFontBold,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Tag No : $tagNo',
              style: kFontBold,
            ),
          ],
        ),
      ),
    );
  }
}

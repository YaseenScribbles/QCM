import 'package:flutter/material.dart';
import 'package:qcm/api/complaint_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/complaint.dart';
import 'package:qcm/pages/complaints/add_complaint.dart';
import 'package:qcm/pages/complaints/edit_complaint.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({super.key});

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  bool isLoading = true;
  int count = 0;
  List<Complaint> complaintList = [];
  ComplaintService service = ComplaintService();

  Future getAllComplaints() async {
    complaintList = [];
    List<dynamic> complaints = await service.getAllComplaints();
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
      count = complaintList.length;
      isLoading = false;
    });
  }

  emptyComplaints() {
    return const Center(
      child: Text(
        "No Complaints",
        style: kFontBold,
      ),
    );
  }

  getListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: ((context, index) {
          return ListTile(
            shape: Border(
              bottom: BorderSide(),
            ),
            title: Text(
              complaintList[index].name.toString(),
              style: kFontBold,
            ),
            subtitle: Text(complaintList[index].segmentName.toString(),
                style: kFontLight),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return EditComplaint(complaint: complaintList[index]);
              }))).then((value) => getAllComplaints());
            },
          );
        }));
  }

  loading() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    super.initState();
    getAllComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAllComplaints,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "COMPLAINTS",
            style: kFontAppBar,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const AddComplaint();
                }))).then((value) => getAllComplaints());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: SafeArea(
          child: kGetDrawer(context),
        ),
        body: isLoading
            ? loading()
            : count == 0
                ? emptyComplaints()
                : getListView(),
      ),
    );
  }
}

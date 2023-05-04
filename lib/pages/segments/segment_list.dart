import 'package:flutter/material.dart';
import 'package:qcm/api/segment_service.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/segment.dart';
import 'package:qcm/pages/segments/add_segment.dart';
import 'package:qcm/pages/segments/edit_segment.dart';

class SegmentList extends StatefulWidget {
  const SegmentList({super.key});

  @override
  State<SegmentList> createState() => _SegmentListState();
}

class _SegmentListState extends State<SegmentList> {
  bool isLoading = true;
  int count = 0;
  List<Segment> segmentList = [];
  SegmentService service = SegmentService();

  Future getAllSegments() async {
    segmentList = [];
    var segments = await service.getAllSegments();
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
    // print(segments[0]['id'].runtimeType);
    // print(segments[0]['name'].runtimeType);
    // print(segments[0]['active'].runtimeType);
    // print(segments[0]['user_id'].runtimeType);
    setState(() {
      count = segmentList.length;
      isLoading = false;
    });
  }

  emptySegments() {
    return const Center(
      child: Text(
        "No Segments",
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
              segmentList[index].name.toString(),
              style: kFontBold,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return EditSegment(segment: segmentList[index]);
              }))).then((value) => getAllSegments());
            },
          );
        }));
  }

  loading() {
    return const Center(child: CircularProgressIndicator());
  }

  loaded() {
    if (count == 0) {
      return emptySegments();
    } else {
      return getListView();
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSegments();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getAllSegments,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "SEGMENTS",
            style: kFontAppBar,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const AddSegment();
                    },
                  )).then((value) => getAllSegments());
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: SafeArea(child: kGetDrawer(context)),
        body: isLoading ? loading() : loaded(),
      ),
    );
  }
}

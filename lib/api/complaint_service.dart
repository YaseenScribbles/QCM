import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/model/complaint.dart';

class ComplaintService {
  getAllComplaints() async {
    var url = Uri.parse('${kURL}complaints');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  getComplaint(int id) async {
    var url = Uri.parse('${kURL}complaints/$id');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  saveComplaint(Complaint complaint) async {
    var url = Uri.parse('${kURL}complaints');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'name': complaint.name,
      'segment_id': complaint.segmentId,
      'user_id': complaint.userId,
    });

    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  updateComplaint(Complaint complaint) async {
    var url = Uri.parse('${kURL}complaints/${complaint.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'name': complaint.name,
      'segment_id': complaint.segmentId,
      'user_id': complaint.userId,
    });

    http.Response response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  activateAndSuspendComplaint(Complaint complaint) async {
    Uri url;
    if (complaint.active!) {
      url = Uri.parse('${kURL}complaints/${complaint.id}/suspended');
    } else {
      url = Uri.parse('${kURL}complaints/${complaint.id}/activate');
    }
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.put(url, headers: headers);
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }
}

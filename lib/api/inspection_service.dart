import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/model/inspection.dart';

class InspectionService {
  getAll(DateTime date) async {
    var url = Uri.parse('${kURL}inspections?date=$date');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  saveInspection(Inspection inspection) async {
    var url = Uri.parse('${kURL}inspections');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'unique_id': inspection.uniqueId,
      'segment_id': inspection.segmentId,
      'complaint_id': inspection.complaintId,
      'remarks': inspection.remarks,
      'company_id': inspection.companyId,
      'user_id': inspection.userId,
    });

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  updateInspection(Inspection inspection) async {
    var url = Uri.parse('${kURL}inspections/${inspection.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'unique_id': inspection.uniqueId,
      'segment_id': inspection.segmentId,
      'complaint_id': inspection.complaintId,
      'remarks': inspection.remarks,
      'company_id': inspection.companyId,
      'user_id': inspection.userId,
    });
    http.Response response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  searchInspection(String tagNo) async {
    var url = Uri.parse('${kURL}inspections/search?tag_no=$tagNo');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  deleteInspection(Inspection inspection) async {
    var url = Uri.parse('${kURL}inspections/${inspection.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }
}

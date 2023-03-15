import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/model/segment.dart';

class SegmentService {
  getAllSegments() async {
    var url = Uri.parse('${kURL}segments');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  saveSegment(Segment segment) async {
    var url = Uri.parse('${kURL}segments');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'name': segment.name,
      'user_id': segment.userId,
    });
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  updateSegment(Segment segment) async {
    var url = Uri.parse('${kURL}segments/${segment.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({'name': segment.name, 'user_id': segment.userId});
    http.Response response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  activateAndSuspendSegment(Segment segment) async {
    Uri url;
    if (segment.active!) {
      url = Uri.parse('${kURL}segments/${segment.id}/suspended');
    } else {
      url = Uri.parse('${kURL}segments/${segment.id}/activate');
    }
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.put(url, headers: headers);
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }
}

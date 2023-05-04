import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';

class SupplierService {
  fetchAllByName(String name) async {
    var url = Uri.parse('${kURL}suppliers?name=$name');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  searchInspection(int supplierId) async {
    var url = Uri.parse('${kURL}suppliers/tags?id=$supplierId');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}

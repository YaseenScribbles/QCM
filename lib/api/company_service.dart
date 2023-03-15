import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/model/company.dart';

class CompanyService {
  saveCompany(Company company) async {
    var url = Uri.parse('${kURL}companies');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({'name': company.name, 'user_id': company.userId});
    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  getAllCompanies() async {
    var url = Uri.parse('${kURL}companies');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  deleteCompany(Company company) async {
    var url = Uri.parse('${kURL}companies/${company.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  updateCompany(Company company) async {
    var url = Uri.parse('${kURL}companies/${company.id}');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({'name': company.name, 'user_id': company.userId});
    http.Response response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  activateAndSuspendCompany(Company company) async {
    Uri url;
    if (company.active!) {
      url = Uri.parse('${kURL}companies/${company.id}/suspended');
    } else {
      url = Uri.parse('${kURL}companies/${company.id}/activate');
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

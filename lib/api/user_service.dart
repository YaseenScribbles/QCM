import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/model/user.dart';

class UserService {
  saveUser(User user) async {
    var url = Uri.parse('${kURL}register');
    var headers = getHeaderWithAuth(userToken);
    final body = jsonEncode({
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'department': user.department,
      'phone': user.phone
    });

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  updatePassword(String oldPassword, String newPassword) async {
    var url = Uri.parse('${kURL}passwordUpdate');
    var headers = getHeaderWithAuth(userToken);
    final body = jsonEncode(
        {'currentPassword': oldPassword, 'newPassword': newPassword});

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      return response.reasonPhrase.toString();
    }
  }
}

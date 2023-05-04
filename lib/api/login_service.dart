import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';
import 'package:qcm/local_db/repository.dart';

class LogInService {
  final Repository _repository = Repository();
  login(String email, String password) async {
    var url = Uri.parse('${kURL}login');

    Map<String, String> headers = kHeaderWithoutAuth;

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      await _repository.saveUserTokenWithEmailAndPassword(json['access_token'],
          email, password, json['role'], json['name'], json['id']);
      userToken = json['access_token'];
      role = json['role'];
      userName = json['name'];
      userId = json['id'];

      return 'Logged In';
    } else {
      return 'Invalid credentials';
    }
  }

  logout() async {
    var url = Uri.parse('${kURL}logout');
    Map<String, String> headers = getHeaderWithAuth(userToken);
    http.Response response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      userName = '';
      userToken = '';
      role = '';
      userId = 0;
      await _repository.updateUserInfo();
      // await _repository.deleteCacheDir();
      // await _repository.deleteAppDir();
      return 'Logged Out';
    } else {
      return response.reasonPhrase.toString();
    }
  }

  getUserId() async {
    var url = Uri.parse('${kURL}user');

    Map<String, String> headers = getHeaderWithAuth(userToken);

    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['id'];
    } else {
      return 1;
    }
  }
}

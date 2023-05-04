import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qcm/library/library.dart';

class LotService {
  fetchByLotNo(String lotNo) async {
    var url = Uri.parse('${kURL}inspections/lot/search?lot_no=$lotNo');
    var headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }
}

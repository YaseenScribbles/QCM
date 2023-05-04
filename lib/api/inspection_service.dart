import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:qcm/library/library.dart';
import 'package:qcm/model/inspection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
      'is_jobwork': inspection.isJobWork,
      'user_id': inspection.userId,
    });

    http.Response response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      var results = await jsonDecode(response.body);
      return results["id"];
    } else {
      return 'Failed';
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

  //   savePicture(XFile image, int inspectionId) async {
  //   //dio package
  //   var url = '${kURL}inspections/asset';
  //   var headers = getHeaderWithAuth(userToken);
  //   var dio = Dio();

  //   File compressedImage = await compressFile(File(image.path));

  //   var formData = FormData.fromMap({
  //     'inspection_id': inspectionId,
  //     'image': await MultipartFile.fromFile(
  //       compressedImage.absolute.path,
  //       filename: image.name,
  //       contentType: new MediaType("image", "jpg"),
  //     ),
  //   });

  //   var response =
  //       await dio.post(url, data: formData, options: Options(headers: headers));

  //   if (response.statusCode == 200) {
  //     return 'Uploaded';
  //   } else {
  //     return response.statusMessage;
  //   }

  //   //http package
  //   // var request = new http.MultipartRequest('POST', url);
  //   // request.files.add(new http.MultipartFile.fromBytes(
  //   //     "file", await image.readAsBytes(),
  //   //     filename: image.name, contentType: new MediaType("image", "jpg")));
  //   // var response = await request.send();
  //   // if (response.statusCode == 200) {
  //   //   return 'Success';
  //   // } else {
  //   //   print(image.path);
  //   //   return response.reasonPhrase.toString();
  //   // }
  // }

  savePicture(int inspectionId) async {
    //dio package
    var url = '${kURL}inspections/asset';
    var headers = getHeaderWithAuth(userToken);
    var dio = Dio();
    List<String> compressedImagePaths = [];
    File compressedImage;
    for (var path in imagePaths) {
      if (path.contains('libCachedImageData')) {
        compressedImage = File(path);
      } else {
        compressedImage = await compressFile(File(path));
      }
      compressedImagePaths.add(compressedImage.absolute.path);
    }
    var formData = FormData.fromMap({
      'inspection_id': inspectionId,
      'image': [
        for (var path in compressedImagePaths)
          {
            await MultipartFile.fromFile(path,
                filename: path.split('/').last,
                contentType: MediaType('image', 'jpg'))
          }.toList()
      ]
    });

    var response =
        await dio.post(url, data: formData, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return response.statusMessage;
    }

    //      formData = FormData.fromMap({
    //   'inspection_id': inspectionId,
    //   'image': await MultipartFile.fromFile(
    //     compressedImage.absolute.path,
    //     filename: path.split("/").last,
    //     contentType: new MediaType("image", "jpg"),
    //   ),
    // });

    //http package
    // var request = new http.MultipartRequest('POST', url);
    // request.files.add(new http.MultipartFile.fromBytes(
    //     "file", await image.readAsBytes(),
    //     filename: image.name, contentType: new MediaType("image", "jpg")));
    // var response = await request.send();
    // if (response.statusCode == 200) {
    //   return 'Success';
    // } else {
    //   print(image.path);
    //   return response.reasonPhrase.toString();
    // }
  }

  // 2. compress file and get file.
  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
    );

    return result!;
  }

  getImageNames(int id) async {
    var url = Uri.parse('${kURL}images/$id');
    var headers = getHeaderWithAuth(userToken);
    http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  getImageByInspectionId(int id) async {
    List<dynamic> results = await getImageNames(id);
    imageURLs = [];
    List<String> paths = [];
    if (results.isNotEmpty) {
      for (var result in results) {
        paths.add(result['image_id']);
      }
      for (var path in paths) {
        imageURLs.add('${kImgURL}/$path');
      }
    }
    return imageURLs;
  }
}

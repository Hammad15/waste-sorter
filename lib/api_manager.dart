import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<String> uploadImage(File imageFile) async {
  print("Entering image upload process");
  var uri = Uri.parse('http://192.168.2.243:8080/api/sort');
  var request = http.MultipartRequest('POST', uri);
  request.files.add(http.MultipartFile.fromBytes('image', imageFile.readAsBytesSync()));

  print('request constructed, request: $request');
  // return Future<String>.delayed(
  //   const Duration(seconds: 2),
  //       () => 'Recycling',
  // );

  var response = await request.send();
  print("Response: $response");
  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);  // Assuming the response is in JSON format
  } else {
    throw Exception('Failed to classify image');
  }
}

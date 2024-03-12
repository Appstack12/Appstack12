import 'dart:convert';

import 'package:fit_for_life/color_codes/index.dart';
import 'package:fit_for_life/services/navigation_service.dart';
import 'package:fit_for_life/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiClass {
  Future<Map<String, dynamic>> onCallPostApi(String url, Object body) async {
    final String token = await SharedPreference.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != '') {
      headers["authorization"] = 'Bearer $token';
    }


    final uri = Uri.parse('${dotenv.env['BASE_URL']}$url');

    print("uri $uri");
    print("uri post ${jsonEncode(body)}");
    http.Response response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: headers,
    );
    dynamic json;

    json = jsonDecode(response.body);
    if (json["status"] == true || response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).clearSnackBars();
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(json["message"]),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      return {};
    }
  }

  
  Future<Map<String, dynamic>> onCallPatchApi(String url, Object body) async {
    final String token = await SharedPreference.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != '') {
      headers["authorization"] = 'Bearer $token';
    }

    final uri = Uri.parse('${dotenv.env['BASE_URL']}$url');

    print("token $token");
    print("uri $uri");
    print("body ${jsonEncode(body)}");
    http.Response response = await http.patch(
      uri,
      body: jsonEncode(body),
      headers: headers,
    );
    dynamic json;
    print("response ${response.body}");
    json = jsonDecode(response.body);
    if (json["status"] == true || response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).clearSnackBars();
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(json["message"]),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      return {};
    }
  }

  Future<Map<String, dynamic>> onCallGetApi(String url) async {
    final String token = await SharedPreference.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token.isNotEmpty) {
      headers["authorization"] = 'Bearer $token';
    }

    print("object '${dotenv.env['BASE_URL']}$url'");
    print("Bearer ${token}");
    final uri = Uri.parse('${dotenv.env['BASE_URL']}$url');

    http.Response response = await http.get(
      uri,
      headers: headers,
    );
    dynamic json;

    json = jsonDecode(response.body);
    if (json["status"] == true || response.statusCode == 200 || response.statusCode == 201) {
      return json;
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).clearSnackBars();
      // ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
      //   // SnackBar(
      //   //   content: Text(json["message"] ?? ''),
      //   //   showCloseIcon: true,
      //   //   closeIconColor: ColorCodes.white,
      //   //   backgroundColor: ColorCodes.red
      //   // ),
      // );
      return {};
    }
  }

  Future<dynamic> onCallMultipartFormApi(String url, String path) async {
    final String token = await SharedPreference.getString('token');

    final uri = Uri.parse('${dotenv.env['BASE_URL']}$url');
    final request = http.MultipartRequest('POST', uri);
    if (token != '') {
      request.headers.addAll({"Authorization": "Bearer $token"});
    }
    request.files.add(await http.MultipartFile.fromPath("image", path));

    final res = await request.send();

    final response = await http.Response.fromStream(res);
    final responseData = json.decode(response.body);

    if (responseData['status']) {
      return responseData;
    } else {
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).clearSnackBars();
      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
          showCloseIcon: true,
          closeIconColor: ColorCodes.white,
          backgroundColor: ColorCodes.red,
        ),
      );
      return responseData;
    }
  }
}

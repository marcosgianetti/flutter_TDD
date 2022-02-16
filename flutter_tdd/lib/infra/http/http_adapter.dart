import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_tdd/data/http/http.dart';
import 'package:http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter({this.client});

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsonBody);
    return response.body.isEmpty || response.statusCode != 200 ? null : jsonDecode(response.body);
  }
}

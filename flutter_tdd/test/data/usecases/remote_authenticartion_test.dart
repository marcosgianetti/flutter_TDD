import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthetication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthetication({
    @required this.httpClient,
    @required this.url,
  });
  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call http client with correct URL', () async {
    //Arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthetication(httpClient: httpClient, url: url);

    //Action
    await sut.auth();

    //Accert
    verify(httpClient.request(url: url));
  });
}

import 'package:faker/faker.dart';
import 'package:flutter_tdd/data/http/http.dart';
import 'package:flutter_tdd/infra/http/http_adapter.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });

  group('shared', () {
    test('Should throw server serro if invalid method is provided', () async {
      final future = sut.request(url: url, method: 'invalid_method');

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('post', () {
    PostExpectation mockRequest() => when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResposnse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() {
      mockResposnse(200);
    });

    test('Should call post with correct values and body', () async {
      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(
        client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{"any_key":"any_value"}',
        ),
      );
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(
        client.post(any, headers: anyNamed('headers')),
      );
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: url, method: 'post');
      expect(response, {"any_key": "any_value"});
    });

    test('Should return null if post returns 200 without body', () async {
      mockResposnse(200, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResposnse(204, body: '');
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResposnse(204);
      final response = await sut.request(url: url, method: 'post');
      expect(response, null);
    });

    test('Should return BadRequestError if post returns 400, without body', () async {
      mockResposnse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError if post returns 400, with body', () async {
      mockResposnse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });
    test('Should return Server if post returns 500, with body', () async {
      mockResposnse(500);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
    test('Should return Server if post returns 401', () async {
      mockResposnse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });
    test('Should return Server if post returns 404', () async {
      mockResposnse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });
    test('Should return Server if post returns 403, with body', () async {
      mockResposnse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbiddon));
    });

    test('Should return Server if post throws', () async {
      mockError();
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.serverError));
    });
  });
}

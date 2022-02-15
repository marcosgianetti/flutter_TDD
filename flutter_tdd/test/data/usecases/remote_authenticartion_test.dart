import 'package:faker/faker.dart';
import 'package:flutter_tdd/domain/helpers/domain_error.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_tdd/data/http/http.dart';

import 'package:flutter_tdd/data/usecases/remote_authentication.dart';
import 'package:flutter_tdd/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams params;

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() =>
      when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    //Arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
    mockttpData(mockValidData());
  });
  test('Should call http client with correct values', () async {
    //Action
    await sut.auth(params);

    //Accert
    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthenticationParams.fromDomain(params).toJson(),
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw invalidCredentialsError if HttpClient returns 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return and account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });
  test('Should throw error if HttpClient returns 200 with invalid data', () async {
    mockttpData({'invalid_kye': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}

import 'package:faker/faker.dart';
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

  setUp(() {
    //Arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test('Should call http client with correct values', () async {
    final params = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
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
}

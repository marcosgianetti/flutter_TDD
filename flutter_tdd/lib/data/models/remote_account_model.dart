import 'package:flutter_tdd/data/http/http.dart';
import 'package:flutter_tdd/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;
  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('accessToken')) {
      throw HttpError.invalidData;
    } else
      return RemoteAccountModel(json['accessToken']);
  }
  AccountEntity toEntity() => AccountEntity(this.accessToken);
}

abstract class LoginPresenter {
  Stream<String> get emailErrorStrem;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormVaidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get mainErrorStream;

  void validateEmail(String email);
  void validatePassword(String email);
  void auth() {}
  void dispose() {}
}

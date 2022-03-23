abstract class LoginPresenter {
  Stream get emailErrorStrem;
  Stream get passwordErrorStream;
  Stream get isFormVaidStream;

  void validateEmail(String email);
  void validatePassword(String email);
}

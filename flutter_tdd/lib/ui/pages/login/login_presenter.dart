abstract class LoginPresenter {
  Stream get emailErrorStrem;

  void validateEmail(String email);
  void validatePassword(String email);
}

import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/login/login_presenter.dart';

import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<bool>(
        stream: presenter.isFormVaidStream,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: snapshot.data == true ? presenter.auth : null,
            child: Text('Entrar'.toUpperCase()),
          );
        });
  }
}

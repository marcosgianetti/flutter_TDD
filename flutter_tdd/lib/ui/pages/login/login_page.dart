import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/pages.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({Key key, this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            HeadLine1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                  child: Column(
                children: [
                  StreamBuilder<String>(
                      stream: presenter.emailErrorStrem,
                      builder: (context, snapshot) {
                        return TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                            errorText: snapshot.data,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: presenter.validateEmail,
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
                      ),
                      obscureText: true,
                      onChanged: presenter.validatePassword,
                    ),
                  ),
                  ElevatedButton(onPressed: null, child: Text('Entrar'.toUpperCase())),
                  FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    label: Text('Criar Conta'),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

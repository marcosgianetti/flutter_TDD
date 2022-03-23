import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/pages.dart';

import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen(
            (isLoading) {
              if (isLoading ?? false) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: SimpleDialog(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Aguarde...', textAlign: TextAlign.center),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
          );

          widget.presenter.mainErrorStream.listen(
            (mensage) {
              if (mensage != '' && mensage != null)
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red.shade900,
                    content: Text(
                      mensage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
            },
          );
          return SingleChildScrollView(
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
                        stream: widget.presenter.emailErrorStrem,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.email, color: Theme.of(context).primaryColorLight),
                              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: widget.presenter.validateEmail,
                          );
                        },
                      ),
                      StreamBuilder<String>(
                        stream: widget.presenter.passwordErrorStream,
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 32),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
                                errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: widget.presenter.validatePassword,
                            ),
                          );
                        },
                      ),
                      StreamBuilder<bool>(
                          stream: widget.presenter.isFormVaidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.data == true ? widget.presenter.auth : null,
                              child: Text('Entrar'.toUpperCase()),
                            );
                          }),
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
          );
        },
      ),
    );
  }
}

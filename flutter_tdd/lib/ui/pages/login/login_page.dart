import 'package:flutter/material.dart';
import 'package:flutter_tdd/ui/pages/pages.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';

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
              if (isLoading ?? false)
                showLoading(context);
              else
                hideLoading(context);
            },
          );

          widget.presenter.mainErrorStream.listen(
            (mensage) {
              if (mensage != '' && mensage != null) showErrorMessage(context, mensage: mensage);
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
                  child: Provider(
                    create: (_) => widget.presenter,
                    child: Form(
                        child: Column(
                      children: [
                        email_input(),
                        PasswordInput(),
                        LoginButton(),
                        FlatButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person),
                          label: Text('Criar Conta'),
                        )
                      ],
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

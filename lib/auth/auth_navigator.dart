import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/auth/confirm/confirmation_view.dart';
import 'package:social_media_app/auth/sign_up/sign_up_view.dart';

import 'auth_cubit.dart';
import 'login/login_view.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Navigator(
          pages: [
            //Show login
            if (state == AuthState.login) MaterialPage(child: LoginView()),
            //Allow push animation
            if (state == AuthState.signUp ||
                state == AuthState.confirmSignUp) ...[
              MaterialPage(child: SignUpView()),
              //Show confirm sign up
              if (state == AuthState.confirmSignUp)
                MaterialPage(child: ConfirmationView()),
            ]
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }
}

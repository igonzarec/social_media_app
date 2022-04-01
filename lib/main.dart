import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/auth/auth_cubit.dart';
import 'package:social_media_app/auth/auth_navigator.dart';
import 'package:social_media_app/auth/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => AuthRepository(),
        child: BlocProvider(
          create: (context) => AuthCubit(),
          child: AuthNavigator(),
        ),
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/auth/auth_cubit.dart';
import 'package:social_media_app/auth/auth_repository.dart';
import 'package:social_media_app/auth/form_submission_status.dart';
import 'package:social_media_app/auth/sign_up/sign_up_event.dart';
import 'package:social_media_app/auth/sign_up/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  SignUpBloc({required this.authRepo, required this.authCubit})
      : super(SignUpState()) {
    on<SignUpUsernameChanged>(_onSignUpUsernameChanged);
    on<SignUpEmailChanged>(_onSignUpEmailChanged);
    on<SignUpPasswordChanged>(_onSignUpPasswordChanged);
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  void _onSignUpUsernameChanged(
      SignUpUsernameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onSignUpEmailChanged(
      SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onSignUpPasswordChanged(
      SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onSignUpSubmitted(
      SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      await authRepo.signUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      authCubit.showConfirmSignUp(
        username: state.username,
        email: state.email,
        password: state.password,
      );
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }

  //To delete
  // Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
  //   // Username updated
  //   if (event is SignUpUsernameChanged) {
  //     yield state.copyWith(username: event.username);
  //
  //     // Email updated
  //   } else if (event is SignUpEmailChanged) {
  //     yield state.copyWith(email: event.email);
  //
  //     // Password updated
  //   } else if (event is SignUpPasswordChanged) {
  //     yield state.copyWith(password: event.password);
  //
  //     // Form submitted
  //   } else if (event is SignUpSubmitted) {
  //     yield state.copyWith(formStatus: FormSubmitting());
  //
  //     try {
  //       await authRepo.signUp(
  //         username: state.username,
  //         email: state.email,
  //         password: state.password,
  //       );
  //       yield state.copyWith(formStatus: SubmissionSuccess());
  //
  //       authCubit.showConfirmSignUp(
  //         username: state.username,
  //         email: state.email,
  //         password: state.password,
  //       );
  //     } catch (e) {
  //       yield state.copyWith(formStatus: SubmissionFailed(e as Exception));
  //     }
  //   }
  // }
}

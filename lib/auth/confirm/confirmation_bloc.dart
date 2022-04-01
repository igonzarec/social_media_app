import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/auth/auth_repository.dart';
import 'package:social_media_app/auth/form_submission_status.dart';
import '../auth_cubit.dart';
import 'confirmation_event.dart';
import 'confirmation_state.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  ConfirmationBloc({
    required this.authRepo,
    required this.authCubit,
  }) : super(ConfirmationState()) {
    on<ConfirmationCodeChanged>(_onConfirmationCodeChanged);
    on<ConfirmationSubmitted>(_onConfirmationSubmitted);
  }

  void _onConfirmationCodeChanged(
      ConfirmationCodeChanged event, Emitter<ConfirmationState> emit) {
    emit(state.copyWith(code: event.code));
  }

  void _onConfirmationSubmitted(
      ConfirmationSubmitted event, Emitter<ConfirmationState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));

    try {
      final userId = await authRepo.confirmSignUp(
        username: authCubit.credentials!.username,
        confirmationCode: state.code,
      );
      print(userId);
      emit(state.copyWith(formStatus: SubmissionSuccess()));

      final credentials = authCubit.credentials;
      credentials!.userId = userId;
      print(credentials);
      authCubit.launchSession(credentials);
    } catch (e) {
      print(e);
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }

  //To be deleted
  Stream<ConfirmationState> mapEventToState(ConfirmationEvent event) async* {
    // Confirmation code updated
    if (event is ConfirmationCodeChanged) {
      yield state.copyWith(code: event.code);

      // Form submitted
    } else if (event is ConfirmationSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await authRepo.confirmSignUp(
          username: authCubit.credentials!.username,
          confirmationCode: state.code,
        );
        print(userId);
        yield state.copyWith(formStatus: SubmissionSuccess());

        final credentials = authCubit.credentials;
        credentials!.userId = userId;
        print(credentials);
        authCubit.launchSession(credentials);
      } catch (e) {
        print(e);
        yield state.copyWith(formStatus: SubmissionFailed(e as Exception));
      }
    }
  }
}

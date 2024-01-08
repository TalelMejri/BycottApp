import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mobile/Core/Strings/failures.dart';
import 'package:mobile/Core/failures/failures.dart';
import 'package:mobile/Features/Auth/domain/entities/login_entity.dart';
import 'package:mobile/Features/Auth/domain/usecases/sign_up_user.dart';
import 'package:mobile/Features/Auth/domain/usecases/verify_email_user.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

  final VerifyEmailUseCase verifyEmailUseCase;
  final SignUpUserUseCase signUpUserUseCase;
  

  SignupBloc({
    required this.verifyEmailUseCase,
    required this.signUpUserUseCase,
  }) : super(SignupInitial()) {
    on<SignupEvent>((event, emit) async {
       if (event is AddUserEvent) {
        emit(LoadingSignupStateState());
        final failureOrDoneMessage = await signUpUserUseCase(event.user);
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, "User Add With Success"));
      }else if (event is VerifyUserEvent) {
        emit(LoadingSignupStateState());
        final failureOrDoneMessage = await verifyEmailUseCase(event.code,event.email);
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, "Email Verified With Success"));
      }
    });
  }

    SignupState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorSignupStateState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageSignupStateState(message: message),
    );
  }


   String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Erreur inconnue. Veuillez réessayer plus tard";
    }
  }
}




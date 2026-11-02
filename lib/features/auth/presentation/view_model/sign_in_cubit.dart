import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._repository) : super(const SignInState());
  final AuthRepository _repository;

  void togglePasswordVisibility() =>
      emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));

  Future<void> signIn({required String email, required String password}) async {
    if (email.trim().isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: 'Enter your email and password',
        ),
      );
      return;
    }
    emit(state.copyWith(status: SignInStatus.submitting));
    try {
      await _repository.signIn(email: email.trim(), password: password);
      emit(state.copyWith(status: SignInStatus.success));
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: 'Please check your connection and try again',
        ),
      );
    }
  }
}

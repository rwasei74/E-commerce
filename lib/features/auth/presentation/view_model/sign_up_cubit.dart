import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';

enum SignUpStatus { initial, submitting, success, failure }

class SignUpState {
  const SignUpState({this.status = SignUpStatus.initial, this.errorMessage});
  final SignUpStatus status;
  final String? errorMessage;
  SignUpState copyWith({SignUpStatus? status, String? errorMessage}) =>
      SignUpState(status: status ?? this.status, errorMessage: errorMessage);
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._repository) : super(const SignUpState());
  final AuthRepository _repository;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final error = _validationError(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    if (error != null) {
      emit(state.copyWith(status: SignUpStatus.failure, errorMessage: error));
      return;
    }
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _repository.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
        phone: phone.trim(),
      );
      emit(state.copyWith(status: SignUpStatus.success));
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: 'Please check your connection and try again',
        ),
      );
    }
  }

  String? _validationError({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    if (name.trim().length < 3) {
      return 'Full name must be at least 3 characters';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return 'Enter a valid email address';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone.trim())) {
      return 'Enter an Egyptian mobile number, e.g. 01012345678';
    }
    return null;
  }
}

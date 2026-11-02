enum SignInStatus { initial, submitting, success, failure }

class SignInState {
  const SignInState({
    this.isPasswordHidden = true,
    this.status = SignInStatus.initial,
    this.errorMessage,
  });
  final bool isPasswordHidden;
  final SignInStatus status;
  final String? errorMessage;
  SignInState copyWith({
    bool? isPasswordHidden,
    SignInStatus? status,
    String? errorMessage,
  }) => SignInState(
    isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );
}

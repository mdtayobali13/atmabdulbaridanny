class SignUpProviderState {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final bool isLoading;

  const SignUpProviderState({
    this.name = "",
    this.email = "",
    this.phoneNumber = "",
    this.password = "",
    this.confirmPassword = "",
    this.isLoading = false,
  });

  SignUpProviderState copyWith({
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? password,
    final String? confirmPassword,
    final bool? isLoading,
  }) {
    return SignUpProviderState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

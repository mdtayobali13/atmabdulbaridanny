class SignUpProviderState {
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String idCardFrontendPart;
  final String idCardBackendPart;
  final String storeName;
  final String storeBio;
  final String storeAddress;
  final String storePhoto;
  final String kycDocument;
  final bool isLoading;
  final bool isCustomer;

  const SignUpProviderState({
    this.confirmPassword = "",
    this.email = "",
    this.idCardBackendPart = "",
    this.idCardFrontendPart = "",
    this.isCustomer = true,
    this.isLoading = false,
    this.name = "",
    this.password = "",
    this.phoneNumber = "",
    this.storeName = "",
    this.storeBio = "",
    this.storeAddress = "",
    this.storePhoto = "",
    this.kycDocument = "",
  });

  SignUpProviderState copyWith({
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? password,
    final String? confirmPassword,
    final String? idCardFrontendPart,
    final String? idCardBackendPart,
    final String? storeName,
    final String? storeBio,
    final String? storeAddress,
    final String? storePhoto,
    final String? kycDocument,
    final bool? isLoading,
    final bool? isCustomer,
  }) {
    return SignUpProviderState(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      idCardFrontendPart: idCardFrontendPart ?? this.idCardFrontendPart,
      idCardBackendPart: idCardBackendPart ?? this.idCardBackendPart,
      storeName: storeName ?? this.storeName,
      storeBio: storeBio ?? this.storeBio,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhoto: storePhoto ?? this.storePhoto,
      kycDocument: kycDocument ?? this.kycDocument,
      isLoading: isLoading ?? this.isLoading,
      isCustomer: isCustomer ?? this.isCustomer,
    );
  }
}

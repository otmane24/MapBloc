part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {
  final String errorMsg;

  PhoneAuthError({required this.errorMsg});
}

class PhoneAuthSubmited extends PhoneAuthState {}

class PhoneOPTVerified extends PhoneAuthState {}

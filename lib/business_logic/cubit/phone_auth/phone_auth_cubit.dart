import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;
  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void> submitPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoading());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+213$phoneNumber',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verficationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verficationCompleted(PhoneAuthCredential credential) async {
    print('PhoneAuthCredential credential ');
    await signIn(credential);
  }

  void verificationFailed(FirebaseAuthException exception) {
    emit(PhoneAuthError(errorMsg: exception.toString()));
    print('verificationFailed : ${exception.toString()}');
  }

  void codeSent(String verificationId, int? resendToken) {
    print('codeSent');
    this.verificationId = verificationId;
    emit(PhoneAuthSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submiteOTP(String optCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: optCode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOPTVerified());
    } catch (error) {
      emit(PhoneAuthError(errorMsg: error.toString()));
    }
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    return FirebaseAuth.instance.currentUser!;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:fluttertoast/fluttertoast.dart';

import '../enums/phone_auth_mode.dart';

final authViewModelProvider =
    ChangeNotifierProvider<AuthViewModel>((ref) => AuthViewModel());


class AuthViewModel extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  late String _verificationId;
  late String phone;
  late String code;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  PhoneAuthMode phoneAuthMode = PhoneAuthMode.EnterPhone;

  void back() {
    phoneAuthMode = PhoneAuthMode.EnterPhone;
    notifyListeners();
  }

  late String displayName;


  void sendOTP({required VoidCallback onVerify}) async {
    loading = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          loading = true;
          user = (await _auth.signInWithCredential(credential)).user;
          onVerify();
          // Fluttertoast.showToast(msg: "Sign in successful");
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            // Fluttertoast.showToast(
            //   msg: "The provided phone number is not valid.",
            // );
          } else
            // Fluttertoast.showToast(msg: e.code);
            loading = false;
        },
        timeout: const Duration(seconds: 0),
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          loading = false;
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          phoneAuthMode = PhoneAuthMode.Verify;
          _verificationId = verificationId;
          loading = false;
        },
      );
    } catch (e) {
      loading = true;
    }
  }

  Future<void> verifyOTP() async {
    loading = true;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: code,
      );

      user = (await _auth.signInWithCredential(credential)).user;

      // Fluttertoast.showToast(msg: "Sign in successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {}
    } catch (e) {
      print(e);
    }
    loading = false;
    phoneAuthMode = PhoneAuthMode.EnterPhone;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}

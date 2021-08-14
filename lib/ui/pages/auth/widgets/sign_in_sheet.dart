import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pin_put/pin_put.dart';

import '../../../../core/providers/key_provider.dart';
import '../../../widgets/loading.dart';
import '../enums/phone_auth_mode.dart';
import '../providers/auth_view_model_provider.dart';

class SignInSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final authModel = watch(authViewModelProvider);
    final _formKey = watch(keyProvder);
    BoxDecoration _pinPutDecoration() {
      return BoxDecoration(
        border: Border.all(color: theme.accentColor),
        borderRadius: BorderRadius.circular(8),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: authModel.phoneAuthMode == PhoneAuthMode.EnterPhone
          ? Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('Sign In'),
                    subtitle: Text('Enter your phone number to proceed.'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      key: ValueKey('1'),
                      onSaved: (v) => authModel.phone = v!,
                      maxLength: 10,
                      autofocus: true,
                      validator: (v) =>
                          v!.isEmpty ? "Enter your phone number" : null,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.call),
                        prefixText: '+91 ',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: !authModel.loading
                        ? MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                authModel.sendOTP(
                                  onVerify: () => Navigator.pop(context),
                                );
                              }
                            },
                            color: theme.accentColor,
                            child: Text('CONTINUE'),
                          )
                        : Loading(),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: authModel.back,
                    ),
                    title: Text('Verify Phone Number'),
                    subtitle: Text('Enter OTP to verify phone number'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: PinPut(
                      fieldsCount: 6,
                      validator: (v) => v!.isEmpty ? "Enter code" : null,
                      onSaved: (v) => authModel.code = v!,
                      onChanged: (v) => authModel.code = v,
                      autofocus: true,
                      submittedFieldDecoration: _pinPutDecoration().copyWith(
                        border: Border.all(
                          color: Colors.green,
                        ),
                      ),
                      selectedFieldDecoration: _pinPutDecoration(),
                      followingFieldDecoration: _pinPutDecoration(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: !authModel.loading
                        ? MaterialButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await authModel.verifyOTP();
                                Navigator.pop(context);
                              }
                            },
                            color: theme.accentColor,
                            child: Text('VERIFY'),
                          )
                        : Loading(),
                  ),
                ],
              ),
            ),
    );
  }
}

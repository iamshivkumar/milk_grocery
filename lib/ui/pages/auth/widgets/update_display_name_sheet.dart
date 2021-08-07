
import 'package:flutter/material.dart';
import 'package:grocery_app/core/providers/key_provider.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:grocery_app/ui/pages/auth/providers/auth_view_model_provider.dart';
import 'package:grocery_app/ui/widgets/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



class UpdateDisplayNameSheet extends ConsumerWidget {
  final String initialValue;

  UpdateDisplayNameSheet({this.initialValue = ''});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _formKey = watch(keyProvder);
    final model = watch(authViewModelProvider);
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Enter your name"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                initialValue: initialValue,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                onSaved: (v) => model.displayName = v!,
                validator: (v) => v!.isEmpty ? "Enter your name" : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: model.loading
                  ? Loading()
                  : MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if(initialValue.isNotEmpty){
                             context.read(repositoryProvider).updateName(model.displayName);
                          } else {
                            await model.updateDisplayName();
                          }
                          Navigator.pop(context);
                        }
                      },
                      color: theme.accentColor,
                      child: Text('SUBMIT'),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

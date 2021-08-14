import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/providers/key_provider.dart';
import '../../../../core/providers/repository_provider.dart';
import '../../../widgets/loading.dart';
import '../providers/auth_view_model_provider.dart';

class UpdateDisplayNameSheet extends ConsumerWidget {
  final String initialValue;

  UpdateDisplayNameSheet({this.initialValue = ''});
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _formKey = watch(keyProvder);
    final model = watch(authViewModelProvider);
    final repository = context.read(repositoryProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Enter your name",
              style: style.headline6,
            ),
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
                        if (initialValue.isNotEmpty) {
                          repository.updateName(model.displayName);
                        } else {
                          repository.createUser(model.displayName);
                        }
                      }
                    },
                    color: theme.accentColor,
                    child: Text('SUBMIT'),
                  ),
          )
        ],
      ),
    );
  }
}

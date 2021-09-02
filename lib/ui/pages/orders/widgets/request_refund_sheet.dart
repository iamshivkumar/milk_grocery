import 'package:flutter/material.dart';
import 'package:grocery_app/core/providers/key_provider.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RequestRefundSheet extends ConsumerWidget {
  const RequestRefundSheet({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final style = theme.textTheme;
    final _formKey = watch(keyProvder);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Request for refund",
                  style: style.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  validator: (v) => v!.isEmpty ? "Enter Reason" : null,
                  onSaved: (v) {
                    context
                        .read(repositoryProvider)
                        .requestForRefundOrder(id: id, reason: v!);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Reason",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  child: Text("SEND"),
                  color: theme.accentColor,
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
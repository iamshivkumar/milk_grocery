import 'package:flutter/material.dart';
import '../../../../core/providers/key_provider.dart';
import '../providers/add_wallet_amount_view_model_provider.dart';
import '../../../../utils/labels.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddWalletAmountSheet extends ConsumerWidget {
  AddWalletAmountSheet();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _formKey = watch(keyProvder);
    final model = watch(addWalletAmountViewModelProvider);

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
              child: Text("Add wallet amount"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                onSaved: (v) => model.amount = v!.isEmpty ? 0 : double.parse(v),
                onChanged: (v) =>
                    model.amount = v.isEmpty ? 0 : double.parse(v),
                validator: (v) => v!.isEmpty ? "Enter Amount" : null,
                decoration: InputDecoration(
                  prefixText: Labels.rupee + " ",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "${Labels.rupee}${(model.amount ?? 0) + model.extra} ${model.extraPercentage} will be added to your wallet.",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context);
                    model.addAmount();
                  }
                },
                color: theme.accentColor,
                child: Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

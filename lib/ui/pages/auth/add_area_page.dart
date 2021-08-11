import 'package:flutter/material.dart';
import 'package:grocery_app/ui/pages/auth/providers/add_area_view_model_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AreaPickPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = Theme.of(context);
    final model = watch(addAreaViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Delivery Address"),
      ),
      body: Stepper(
        currentStep: model.currentStep,
        onStepTapped: model.mobile.length == 10 ? model.setStep : null,
        controlsBuilder: (context, {onStepCancel, onStepContinue}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              model.currentStep > 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: TextButton(
                        onPressed: model.back,
                        child: Text(model.currentStep == 0 ? 'CANCEL' : 'BACK'),
                      ),
                    )
                  : SizedBox(),
              MaterialButton(
                child: Text("CONTINUE"),
                onPressed:
                    model.currentStep == 0 && model.mobile.length == 10 ||
                            model.currentStep == 1 && model.area != null ||
                            model.currentStep == 2 &&
                                model.number.isNotEmpty &&
                                model.landmark.isNotEmpty
                        ? onStepContinue
                        : null,
                color: theme.accentColor,
              ),
            ],
          ),
        ),
        onStepContinue: () {
          if (model.currentStep == 2) {
            model.addAddress(
              afterEdit: (){
                Navigator.pop(context);
              }
            );
          } else if (model.currentStep == 0) {
            model.getMilkMan(onError: (v) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(v),
                ),
              );
            });
          } else {
            model.next();
          }
        },
        onStepCancel: () =>
            model.currentStep == 0 ? Navigator.pop(context) : model.back(),
        type: StepperType.vertical,
        steps: [
          Step(
            isActive: true,
            title: Text("Milk Man"),
            state: model.currentStep == 0
                ? StepState.editing
                : model.currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
            content: Column(
              children: [
                SizedBox(height: 8),
                TextFormField(
                  initialValue: model.mobile,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Milk Man Mobile Number",
                    prefixText: "+91 ",
                  ),
                  onChanged: (v) => model.mobile = v,
                ),
              ],
            ),
          ),
          Step(
            isActive: model.areas.isNotEmpty,
            state: model.currentStep == 1
                ? StepState.editing
                : model.currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
            title: Text("Area"),
            content: Column(
              children: [
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Area"),
                  items: model.areas
                      .map(
                        (e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                  value: model.area,
                  onChanged: (v) => model.area = v,
                ),
              ],
            ),
          ),
          Step(
            state: model.currentStep == 2
                ? StepState.editing
                : model.number.isNotEmpty && model.landmark.isNotEmpty
                    ? StepState.complete
                    : StepState.indexed,
            isActive: model.area != null,
            title: Text("House /Flat/ Block No & Landmark"),
            content: Column(
              children: [
                SizedBox(height: 8),
                TextFormField(
                  initialValue: model.number,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "House /Flat/ Block No",
                  ),
                  onChanged: (v) => model.number = v,
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: model.landmark,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: "Landmark",
                  ),
                  onChanged: (v) => model.landmark = v,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

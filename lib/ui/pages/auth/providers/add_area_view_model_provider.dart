import 'package:flutter/foundation.dart';
import 'package:grocery_app/core/models/profile.dart';
import 'package:grocery_app/core/providers/profile_provider.dart';
import 'package:grocery_app/core/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addAreaViewModelProvider =
    ChangeNotifierProvider((ref) => AddAreaViewModel(ref));

class AddAreaViewModel extends ChangeNotifier {
  final ProviderReference _ref;

  AddAreaViewModel(this._ref);

  Repository get _repository => _ref.read(repositoryProvider);
  Profile get _profile => _ref.read(profileProvider).data!.value;

  int currentStep = 0;

  void setStep(int value) {
    currentStep = value;
    notifyListeners();
  }

  void back() {
    currentStep--;
    notifyListeners();
  }

  void next() {
    currentStep++;
    notifyListeners();
  }

  String _mobile = '';
  String get mobile => _mobile;
  set mobile(String mobile) {
    _mobile = mobile;
    notifyListeners();
  }

  String? _area;
  String? get area => _area;
  set area(String? area) {
    _area = area;
    notifyListeners();
  }

  String _number = '';
  String get number => _number;
  set number(String number) {
    _number = number;
    notifyListeners();
  }

  String _landmark = '';
  String get landmark => _landmark;
  set landmark(String landmark) {
    _landmark = landmark;
    notifyListeners();
  }

  bool _forEdit = false;

  void initializeForEdit(Profile profile) {
    _mobile = profile.milkManId!;
    _number = profile.number!;
    _landmark = profile.landMark!;
    _area = profile.area!;
    _forEdit = true;
  }

  List<String> _areas = [];
  List<String> get areas => _areas;
  set areas(List<String> areas) {
    _areas = areas;
    notifyListeners();
  }

  Future<void> getMilkMan({required Function(String) onError}) async {
    try {
      areas = await _repository.getAreas(mobile);
      next();
    } catch (e) {
      onError(e.toString());
    }
  }

  void addAddress({required VoidCallback afterEdit}) {
    try {
      _repository.addAddress(_profile.copyWith(
        area: area,
        number: number,
        landMark: landmark,
        milkManId: _mobile,
      ));
      if(_forEdit=true){
        afterEdit();
      }
    } catch (e) {}
  }
}

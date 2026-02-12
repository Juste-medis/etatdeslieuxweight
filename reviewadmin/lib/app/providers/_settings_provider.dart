// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/models/_plan.dart';

class SettingsProvider extends ChangeNotifier {
  double proccurationQuantity = 1;
  double reviewQuantity = 1;
  double proccurationPrice = 29.90;
  double reviewPrice = 8;
  bool _isLoading = false;
  Map<String, dynamic> _settings = {};
  final List<Plan> _plans = [];

  List<Plan> get plans => _plans;

  Map<String, dynamic> get settings => _settings;
  bool get isLoading => _isLoading;

  void updateSettings(String key, dynamic value) {
    _settings[key] = value;

    notifyListeners();
  }

  Future<void> fetchPlans({bool refresh = false, String type = ""}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    if (refresh) {
      _plans.clear();
      notifyListeners();
    }

    try {
      final response = await getplans(page: 1, limit: "10", filter: {});

      if (response.status == true) {
        if (refresh) {
          _plans.clear();
        }
        _plans.addAll(response.list);

        notifyListeners();
      }
    } catch (err) {
      _isLoading = false;

      debugPrint('Error fetching plans: $err');
      my_inspect(err);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSettings({bool refresh = false, String type = ""}) async {
    if (_isLoading && !refresh) return;

    _isLoading = true;
    if (refresh) {
      notifyListeners();
    }

    try {
      final response = await getSettings("");

      if (response.status == true) {
        // Assuming response contains settings data
        // Update your settings state here
        notifyListeners();
      }
    } catch (err) {
      debugPrint('Error fetching settings: $err');
      my_inspect(err);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPlan(Plan plan) async {
    _isLoading = true;
    notifyListeners();

    // Create your final payload
    Map<String, dynamic> payload = {
      ...plan.toJson(),
    };

    try {
      var raw = await addaPlan(payload);
      if (raw.status == true) {
        fetchPlans(refresh: true);
      }
    } catch (e) {
      my_inspect(e);
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
    _isLoading = false;
    notifyListeners();
    return Future.value(true);
  }

  Future<bool> editPlan(Plan plan) async {
    _isLoading = true;
    my_inspect(plan);
    notifyListeners();

    // Create your final payload
    Map<String, dynamic> payload = {
      ...plan.toJson(),
    };

    try {
      var raw = await editaPlan(plan.id!, payload);
      if (raw.status == true) {
        fetchPlans(refresh: true);
      }
    } catch (e) {
      my_inspect(e);
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
    _isLoading = false;
    notifyListeners();
    myprint(isLoading);
    return Future.value(true);
  }

  Future<void> updateProccurationQuantity(double quantity) async {
    proccurationQuantity = quantity;
    notifyListeners();
  }

  Future<void> updateReviewQuantity(double quantity) async {
    reviewQuantity = quantity;
    notifyListeners();
  }

  Future<void> updateProccurationPrice(double price) async {
    proccurationPrice = price;
    notifyListeners();
  }

  Future<void> updateReviewPrice(double price) async {
    reviewPrice = price;
    notifyListeners();
  }

  Future<void> initializePayment() async {}
}

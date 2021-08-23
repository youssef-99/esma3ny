import 'package:esma3ny/core/exceptions/exceptions.dart';
import 'package:esma3ny/data/models/public/fees.dart';
import 'package:esma3ny/repositories/therapist/therapist_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeesState extends ChangeNotifier {
  TherapistRepository _therapistRepository = TherapistRepository();
  Map<String, dynamic> _errors = {};
  bool _isUpdated = false;
  bool _loading = false;
  String _accountType = '';

  Future<void> edit(Fees fees) async {
    _loading = true;
    _errors = {};
    _isUpdated = false;
    String _msg = '';
    notifyListeners();

    await ExceptionHandling.hanleToastException(
      () async {
        try {
          _msg = await _therapistRepository.updateFees(fees, _accountType);
          Fluttertoast.showToast(msg: _msg, timeInSecForIosWeb: 5);
          _isUpdated = true;
          notifyListeners();
        } on InvalidData catch (e) {
          _errors = e.errors;
          notifyListeners();
          throw InvalidData(_errors);
        }
      },
      _msg,
      false,
    );
    _loading = false;
    notifyListeners();
  }

  setAccountValue(String accountType) {
    _accountType = accountType;
  }

  Map<String, dynamic> get errors => _errors;
  bool get isUpdated => _isUpdated;
  bool get loading => _loading;
}

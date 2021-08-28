import 'package:flutter/material.dart';

class SearchBarState extends ChangeNotifier {
  bool _isSearchPressed = false;
  TextEditingController searchController = TextEditingController();
  String searchTerm = '';

  searchPressed() {
    _isSearchPressed = !_isSearchPressed;
    notifyListeners();
  }

  onSubmitted(value) async {
    searchTerm = value;
    notifyListeners();
  }

  bool get isSearchPressed => _isSearchPressed;
}

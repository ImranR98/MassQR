import 'dart:collection';

import 'package:flutter/material.dart';

class ScansModel extends ChangeNotifier {
  final List<String> _scans = [];

  UnmodifiableListView<String> get scans => UnmodifiableListView(_scans);

  void add(String item) {
    _scans.add(item);
    notifyListeners();
  }

  void removeAll() {
    _scans.clear();
    notifyListeners();
  }
}

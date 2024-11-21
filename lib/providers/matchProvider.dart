import 'package:flutter/material.dart';

class Match {
  final String name;
  final String matchId;

  Match({required this.name, required this.matchId});
}

class MatchProvider with ChangeNotifier {
  final List<Match> _matches = [];

  List<Match> get matches => _matches;

  bool get hasMatches => _matches.isNotEmpty;

  void addMatch(Match match) {
    _matches.add(match);
    notifyListeners();
  }

  void clearMatches() {
    _matches.clear();
    notifyListeners();
  }
}

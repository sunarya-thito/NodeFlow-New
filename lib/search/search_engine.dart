import 'package:flutter/material.dart';
import 'package:nodeflow/application.dart';
import 'package:nodeflow/i18n/internationalization.dart';

class SearchEngine extends Context {
  final List<SearchService> _services = [];

  final List<String> _savedQueries = [];

  List<SearchService> get services => List.unmodifiable(_services);

  List<String> getTabCompletion(String start) {
    // get tab completion (or suggestion) based on the "start" and _savedQueries
    List<String> suggestions = [];
    String lastStartWord = start.split(" ").last;
    for (String query in _savedQueries) {
      var words = query.split(" ");
      // if the lastStartWords contains somewhere in words, then add the rest of the words (excluding the lastStartWord)
      int index = words.indexOf(lastStartWord) + 1;
      if (index < words.length) {
        String suggestion = "";
        for (; index < words.length; index++) {
          suggestion += "${words[index]} ";
        }
        suggestions.add(suggestion);
      }
    }
    return suggestions;
  }

  // executed when one of the search result is chosen
  void saveQuery(String query) {
    _savedQueries.add(query);
    // limit to 50 queries
    if (_savedQueries.length > 50) {
      _savedQueries.removeAt(0);
    }
    notifyListeners();
  }

  void register(SearchService service) {
    _services.add(service);
    notifyListeners();
  }

  void unregister(SearchService service) {
    _services.remove(service);
    notifyListeners();
  }

  List<SearchResult> search(String query) {
    List<SearchResult> results = [];
    for (SearchService service in _services) {
      results.addAll(service.search(query));
    }
    results.sort((a, b) => b.score.compareTo(a.score)); // sort from highest score
    return results;
  }
}

abstract class SearchService {
  List<SearchResult> search(String query);
}

class SearchResult {
  final int score; // score determined by relevance
  final Widget icon;
  final Intl title;
  final Intl description;
  final void Function() onTap;

  const SearchResult({
    required this.score,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });
}

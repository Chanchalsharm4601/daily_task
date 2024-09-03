import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<String> _allWords;
  final Function _updateFilteredWords;

  CustomSearchDelegate(this._allWords, this._updateFilteredWords);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _updateFilteredWords();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = query.isEmpty
        ? _allWords
        : _allWords.where((word) => word.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]),
          onTap: () {
            query = suggestions[index];
            _updateFilteredWords();
            showResults(context);
          },
        );
      },
    );
  }
}

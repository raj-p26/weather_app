import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CustomSearchDelegate extends SearchDelegate {
  late List<String> searchTerms;

  Future<List<String>> _loadCities() async {
    final String response = await rootBundle.loadString("cities.txt");
    final List<String> cityNames =
        response.split(',').map((e) => e.trim()).toList();

    return cityNames;
  }

  CustomSearchDelegate() {
    _loadCities().then((value) {
      searchTerms = value;
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = searchTerms
        .where(
          (element) => element.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var result = searchResults[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            showResults(context);
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result;
            showResults(context);
            close(context, result);
          },
        );
      },
    );
  }
}

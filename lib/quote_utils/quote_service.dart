import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../model/quote.dart';
import 'quote_exception.dart';
import 'quote_result.dart';

class QuoteService {
  final Box _boxApp = Hive.box("app");
  final Box _boxQuotes = Hive.box("quotes");
  final Box _boxFavourite = Hive.box("favouriteQuotes");

  Future<Result> initToday() async {
    final DateTime? lastUpdated = _boxApp.get("lastUpdated");

    if (lastUpdated == null || _getDate().isAfter(lastUpdated)) {
      return refresh();
    }

    final Map<String, dynamic> json =
        Map.castFrom(_boxQuotes.get(_getDate().toIso8601String()));

    return Success(quote: Quote.formJson(json));
  }

  Future<Result> refresh() async {
    try {
      final Quote todayQuote = await _getTodayQuote();

      _boxApp.put("lastUpdated", _getDate());
      _boxQuotes.put(_getDate().toIso8601String(), todayQuote.toMap());

      return Success(quote: todayQuote);
    } catch (e) {
      if (e is QuoteException) {
        return Failed(e.message);
      }

      return const Failed();
    }
  }

  Future<Quote> _getTodayQuote() async {
    Uri url = Uri.parse("https://zenquotes.io/api/today");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> json = List.from(jsonDecode(response.body)).first;
        json["date"] = _getDate().toIso8601String();

        return Quote.formJson(json);
      } else {
        throw const QuoteFetchException("Please try again later.");
      }
    } on QuoteException {
      rethrow;
    } on SocketException {
      throw const QuoteConnectivityException("Check Network Connectivity");
    } catch (e) {
      throw const QuoteUnknownException("Something went wrong");
    }
  }

  Future<List<Quote>> getViewedQuotes() async {
    return _boxQuotes.values
        .map<Map<String, dynamic>>((e) => Map.castFrom(e))
        .map((e) => Quote.formJson(e))
        .toList();
  }

  Future<List<Quote>> getFavouriteQuotes() async {
    return _boxFavourite.values
        .map<Map<String, dynamic>>((e) => Map.castFrom(e))
        .map((e) => Quote.formJson(e))
        .toList();
  }

  Future<bool> addFavouriteQuotes(Quote quote) async {
    final String key = quote.date.toIso8601String();

    if (_boxFavourite.containsKey(key)) {
      return false;
    }

    await _boxFavourite.put(key, quote.toMap());
    return true;
  }

  Future<void> deleteFavouriteQuotes(int index) async {
    await _boxFavourite.deleteAt(index);
  }

  Future<int> clearViewedQuotes() async {
    return _boxQuotes.clear();
  }

  Future<int> clearFavouriteQuotes() async {
    return _boxFavourite.clear();
  }
}

DateTime _getDate() {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

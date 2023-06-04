import 'package:flutter/material.dart';

import '../model/quote.dart';
import 'quote_result.dart';
import 'quote_service.dart';

class QuoteProvider extends ChangeNotifier {
  final QuoteService _quoteService = QuoteService();

  Result fetchState = const Loading();
  List<Quote> viewedQuotes = [];
  List<Quote> favouriteQuotes = [];

  Future<void> init() async {
    fetchState = await _quoteService.initToday();
    viewedQuotes = await _quoteService.getViewedQuotes();
    favouriteQuotes = await _quoteService.getFavouriteQuotes();
    notifyListeners();
  }

  Future<void> refresh() async {
    fetchState = const Loading();
    notifyListeners();
    fetchState = await _quoteService.refresh();
    viewedQuotes = await _quoteService.getViewedQuotes();
    notifyListeners();
  }

  Future<bool> setFavouriteQuote(Quote quote) async {
    final bool result = await _quoteService.addFavouriteQuotes(quote);

    if (result) {
      favouriteQuotes = await _quoteService.getFavouriteQuotes();
      notifyListeners();
    }

    return result;
  }

  Future<void> deleteFavouriteQuote(int index) async {
    await _quoteService.deleteFavouriteQuotes(index);
    favouriteQuotes.removeAt(index);
    notifyListeners();
  }

  Future<void> clearViewedQuotes() async {
    await _quoteService.clearViewedQuotes();
    viewedQuotes.clear();
    notifyListeners();
  }

  Future<void> clearFavouriteQuotes() async {
    await _quoteService.clearFavouriteQuotes();
    favouriteQuotes.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';
import '../quote_utils/quote_provider.dart';
import '../quote_widgets/quote_card.dart';

class FavouriteQuotes extends StatelessWidget {
  const FavouriteQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Quote> favouriteQuotes =
        context.watch<QuoteProvider>().favouriteQuotes;
    return ListView.builder(
      itemCount: favouriteQuotes.length,
      itemBuilder: (context, index) {
        final quote = favouriteQuotes[index];
        return Dismissible(
          key: Key(quote.date.toString()),
          onDismissed: (DismissDirection direction) {
            context.read<QuoteProvider>().deleteFavouriteQuote(index);
          },
          child: QuoteCard(quote: quote),
        );
      },
    );
  }
}

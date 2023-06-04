import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';
import '../quote_utils/quote_provider.dart';
import '../quote_utils/quote_result.dart';
import '../quote_widgets/quote_card.dart';
import 'error.dart';

class TodayQuote extends StatelessWidget {
  const TodayQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Result result = context.watch<QuoteProvider>().fetchState;
    return switch (result) {
      Success(quote: final quote) => FavouriteQuoteCard(quote: quote),
      Failed(message: final message) => ErrorScreen(message: message),
      Loading() => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
    };
  }
}

class FavouriteQuoteCard extends StatelessWidget {
  const FavouriteQuoteCard({Key? key, required this.quote}) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onDoubleTap: () async {
            final bool result =
                await context.read<QuoteProvider>().setFavouriteQuote(quote);

            if (context.mounted) {
              if (result) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Quote Added")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added previously")));
              }
            }
          },
          child: QuoteCard(quote: quote),
        ),
        Text(
          "Double tab to add quote as favourite",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontStyle: FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

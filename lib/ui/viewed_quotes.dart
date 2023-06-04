import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/quote.dart';
import '../quote_utils/quote_provider.dart';
import '../quote_widgets/quote_card.dart';

class ViewedQuotes extends StatelessWidget {
  const ViewedQuotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Quote> viewedQuotes = context.watch<QuoteProvider>().viewedQuotes;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("Viewed Quotes"),
        actions: [
          IconButton(
            onPressed: () => context.read<QuoteProvider>().clearViewedQuotes(),
            icon: const Icon(Icons.clear_all_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: viewedQuotes.length,
        itemBuilder: (context, index) {
          return QuoteCard(
            quote: viewedQuotes[index],
          );
        },
      ),
    );
  }
}

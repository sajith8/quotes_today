import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../quote_utils/quote_provider.dart';
import 'favourite_quotes.dart';
import 'today_quote.dart';
import 'viewed_quotes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _buildBody = const [TodayQuote(), FavouriteQuotes()];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<QuoteProvider>(context, listen: false).init();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("Quotes"),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
        actions: [
          if (_selectedIndex == 0)
            Row(
              children: [
                IconButton(
                  onPressed: () => context.read<QuoteProvider>().refresh(),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    final QuoteProvider value = context.read<QuoteProvider>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider.value(
                            value: value,
                            builder: (context, child) => const ViewedQuotes(),
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility_rounded),
                ),
              ],
            ),
          if (_selectedIndex == 1)
            IconButton(
              onPressed: () =>
                  context.read<QuoteProvider>().clearFavouriteQuotes(),
              icon: const Icon(Icons.clear_all_rounded),
            ),
        ],
      ),
      body: _buildBody[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
          size: 40,
          color: Theme.of(context).colorScheme.secondary,
        ),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote_rounded),
            label: 'Quote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded),
            label: 'Favourite',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quote_utils/quote_provider.dart';
import 'ui/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlexThemeData.light(scheme: FlexScheme.bigStone),
      home: ChangeNotifierProvider(
        create: (context) => QuoteProvider(),
        child: const Home(),
      ),
    );
  }
}

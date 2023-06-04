import '../model/quote.dart';

sealed class Result {
  const Result();
}

final class Success implements Result {
  const Success({
    required this.quote,
  });

  final Quote quote;
}

final class Failed implements Result {
  const Failed([this.message = "Something Went Wrong"]);

  final String message;
}

final class Loading implements Result {
  const Loading();
}

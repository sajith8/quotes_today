final class Quote {
  const Quote({
    required this.quote,
    required this.author,
    required this.date,
  });

  factory Quote.formJson(Map<String, dynamic> json) {
    return Quote(
      quote: json["q"],
      author: json["a"],
      date: DateTime.parse(json["date"]),
    );
  }

  final String quote;
  final String author;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return {
      "q": quote,
      "a": author,
      "date": date.toIso8601String(),
    };
  }
}

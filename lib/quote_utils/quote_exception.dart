interface class QuoteException {
  const QuoteException(this.message);

  final String message;
}

final class QuoteFetchException implements QuoteException {
  const QuoteFetchException(this.message);

  @override
  final String message;
}

final class QuoteUnknownException implements QuoteException {
  const QuoteUnknownException(this.message);

  @override
  final String message;
}

final class QuoteConnectivityException implements QuoteException {
  const QuoteConnectivityException(this.message);

  @override
  final String message;
}

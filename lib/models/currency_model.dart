class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final bool isBase;
  final double rate;

  CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.isBase,
    required this.rate,
  });

  CurrencyModel copyWith({
    String? code,
    String? name,
    String? symbol,
    bool? isBase,
    double? rate,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      isBase: isBase ?? this.isBase,
      rate: rate ?? this.rate,
    );
  }
}

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

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'is_base': isBase ? 1 : 0,
      'rate': rate,
    };
  }

  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      isBase: (map['is_base'] == 1 || map['is_base'] == true),
      rate: (map['rate'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

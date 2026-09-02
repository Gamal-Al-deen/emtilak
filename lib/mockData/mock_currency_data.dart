import '../models/currency_model.dart';

final List<CurrencyModel> initialMockCurrencies = [
  CurrencyModel(
    code: 'USD',
    name: 'دولار أمريكي',
    symbol: '\$',
    isBase: true,
    rate: 1.0,
  ),
  CurrencyModel(
    code: 'SAR',
    name: 'ريال سعودي',
    symbol: '﷼',
    isBase: false,
    rate: 3.75,
  ),
  CurrencyModel(
    code: 'YER',
    name: 'ريال يمني',
    symbol: '﷼',
    isBase: false,
    rate: 530.0,
  ),
];

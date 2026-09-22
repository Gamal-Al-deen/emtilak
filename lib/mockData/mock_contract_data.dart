import '../models/contract_model.dart';

final List<Contract> initialMockContracts = [
  Contract(
    id: '105',
    tenantName: 'محمد أحمد',
    unitName: 'A102 - عمارة القدس',
    buildingName: 'عمارة القدس',
    monthlyRent: 500,
    currency: 'USD',
    startDate: '2024/01/01',
    endDate: '2025/12/31',
    status: 'نشط',
  ),
  Contract(
    id: '104',
    tenantName: 'أحمد علي',
    unitName: 'B101 - عمارة النور',
    buildingName: 'عمارة النور',
    monthlyRent: 450,
    currency: 'USD',
    startDate: '2024/02/01',
    endDate: '2025/12/31',
    status: 'نشط',
  ),
  Contract(
    id: '103',
    tenantName: 'عبدالله حسين',
    unitName: 'A101 - عمارة القدس',
    buildingName: 'عمارة القدس',
    monthlyRent: 500,
    currency: 'USD',
    startDate: '2023/01/01',
    endDate: '2023/12/31',
    status: 'منتهي',
  ),
];

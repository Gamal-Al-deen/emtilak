import '../models/payment_model.dart';

final List<Payment> initialMockPayments = [
  Payment(
    id: 'p1',
    tenantName: 'محمد أحمد',
    contractInfo: '#105 - A102',
    amount: 500,
    currency: '\$',
    paymentDate: '2024/05/01',
    status: 'مدفوع',
    method: 'نقداً (Cash)',
  ),
  Payment(
    id: 'p2',
    tenantName: 'أحمد علي',
    contractInfo: '#104 - B101',
    amount: 250,
    currency: '\$',
    paymentDate: '2024/05/01',
    status: 'جزئي',
    method: 'تحويل بنكي',
  ),
  Payment(
    id: 'p3',
    tenantName: 'عبدالله حسين',
    contractInfo: '#103 - A101',
    amount: 500,
    currency: '\$',
    paymentDate: '2024/04/30',
    status: 'متأخر',
    method: 'غير مدفوع بعد',
  ),
  Payment(
    id: 'p4',
    tenantName: 'يوسف محمد',
    contractInfo: '#102 - B103',
    amount: 450,
    currency: '\$',
    paymentDate: '2024/05/01',
    status: 'مدفوع',
    method: 'نقداً (Cash)',
  ),
];

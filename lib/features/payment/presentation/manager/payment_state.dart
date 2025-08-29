import '../../domain/entities/payment_entity.dart';

abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentEntity payment;

  const PaymentSuccess(this.payment);
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);
}

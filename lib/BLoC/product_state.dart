part of 'product_bloc.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}
class ProductLoading extends ProductState{}

class ProductSucceed extends ProductState{
  final List<Product> products;
  ProductSucceed({required this.products});
}
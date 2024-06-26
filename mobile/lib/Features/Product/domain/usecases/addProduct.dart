import 'package:dartz/dartz.dart';
import 'package:com.talel.boycott/Core/failures/failures.dart';
import 'package:com.talel.boycott/Features/Product/domain/entities/Product.dart';
import 'package:com.talel.boycott/Features/Product/domain/repositories/ProductRepository.dart';

class AddProductUsecase {
  final ProductRepository repository;
  
  AddProductUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Product product) async {
    return await repository.AddProduct(product);
  }

}
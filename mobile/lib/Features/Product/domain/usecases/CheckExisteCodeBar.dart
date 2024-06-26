import 'package:com.talel.boycott/Core/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:com.talel.boycott/Features/Product/domain/entities/Product.dart';
import 'package:com.talel.boycott/Features/Product/domain/repositories/ProductRepository.dart';

class CheckProductUsecase {
  final ProductRepository repository;

  CheckProductUsecase(this.repository);

  Future<Either<Failure, Product>> call(String code_fabricant) async {
    return await repository.CheckExisteProduct(code_fabricant);
  }
  
}
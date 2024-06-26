import 'package:com.talel.boycott/Core/failures/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:com.talel.boycott/Features/Product/domain/entities/Product.dart';
import 'package:com.talel.boycott/Features/Product/domain/repositories/ProductRepository.dart';

class GetAllRequestProductUsecase {
  final ProductRepository repository;

  GetAllRequestProductUsecase(this.repository);

  Future<Either<Failure, List<Product>>> call(int category_id) async {
    return await repository.getAllRequestProduct(category_id);
  }
}

import 'package:dartz/dartz.dart';
import 'package:com.talel.boycott/Core/failures/failures.dart';
import 'package:com.talel.boycott/Features/Product/domain/repositories/ProductRepository.dart';


class RejectProductUsecase {
  final ProductRepository repository;

  RejectProductUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.RejectProduct(id);
  }
  
}
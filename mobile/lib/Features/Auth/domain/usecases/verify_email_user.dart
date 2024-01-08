import 'package:dartz/dartz.dart';
import 'package:mobile/Core/failures/failures.dart';
import 'package:mobile/Features/Auth/domain/entities/login_entity.dart';
import 'package:mobile/Features/Auth/domain/repositories/UserRepository.dart';


class VerifyEmailUseCase {
  final UserRepository userRepository;

  VerifyEmailUseCase(this.userRepository);
      Future<Either<Failure, Unit>> call(String code,String email) async {
        return await userRepository.VerifyEmail(code, email);
      }
}
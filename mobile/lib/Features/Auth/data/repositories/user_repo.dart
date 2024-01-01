import 'package:dartz/dartz.dart';
import 'package:mobile/Core/failures/exception.dart';
import 'package:mobile/Core/failures/failures.dart';
import 'package:mobile/Core/network/network_info.dart';
import 'package:mobile/Features/Auth/data/datasource/user_local_data_source.dart';
import 'package:mobile/Features/Auth/data/datasource/user_remote_data_source.dart';
import 'package:mobile/Features/Auth/data/model/UserModelLogin.dart';
import 'package:mobile/Features/Auth/domain/entities/login_entity.dart';
import 'package:mobile/Features/Auth/domain/entities/signup_entity.dart';
import 'package:mobile/Features/Auth/domain/repositories/UserRepository.dart';


class UserRepositoryImpl extends UserRepository {

  final NetworkInfo networtkInfo;
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl(
      {required this.networtkInfo,
      required this.userLocalDataSource,
      required this.userRemoteDataSource});
      
  @override
  Future<Either<Failure, Unit>> signIn(LoginEntity user) async {
    final UserModelLogin userModel =
        UserModelLogin(email: user.email, password: user.password);
    if (await networtkInfo.isConnected) {
      try {
        final remoteUser = await userRemoteDataSource.signInUser(userModel);
        userLocalDataSource.cacheUser(remoteUser);
        return const Right(unit);
      } on LoginException {
        return Left(LoginFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    userLocalDataSource.clearCachedUser();
    return const Right(unit);
  }

  @override
  Future<LoginEntity?> getCachedUser() async {
    try {
      final UserModelLogin? userModel = await userLocalDataSource.getCachedUser();
      if (userModel == null) {
        return null;
      }
      LoginEntity userEntity = LoginEntity(
          email: userModel.email,
          password: userModel.password,
          id: userModel.id,
          nom: userModel.nom,
          photo: userModel.photo,
          prenom: userModel.prenom,
          role: userModel.role,
          accessToken: userModel.accessToken);
      return userEntity;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(SignUpEntity user) async {
    try {
       return Left(LoginFailure());
    } catch (e) {
       return Left(LoginFailure());
    }
  }

}
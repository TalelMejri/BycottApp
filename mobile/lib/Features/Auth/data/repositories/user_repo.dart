import 'package:dartz/dartz.dart';
import 'package:com.talel.boycott/Core/failures/exception.dart';
import 'package:com.talel.boycott/Core/failures/failures.dart';
import 'package:com.talel.boycott/Core/network/network_info.dart';
import 'package:com.talel.boycott/Features/Auth/data/datasource/user_local_data_source.dart';
import 'package:com.talel.boycott/Features/Auth/data/datasource/user_remote_data_source.dart';
import 'package:com.talel.boycott/Features/Auth/data/model/UserModelLogin.dart';
import 'package:com.talel.boycott/Features/Auth/domain/entities/Payload.dart';
import 'package:com.talel.boycott/Features/Auth/domain/entities/login_entity.dart';
import 'package:com.talel.boycott/Features/Auth/domain/repositories/UserRepository.dart';

typedef Future<Unit> AddOrVerifyUser();
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
          prenom: userModel.prenom,
          role: userModel.role,
          accessToken: userModel.accessToken);
      return userEntity;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(LoginEntity user) async {
    final UserModelLogin userModel =
        UserModelLogin(email: user.email, password: user.password,nom: user.nom,prenom: user.prenom);   
        return await _getMessage(() {
           return userRemoteDataSource.signUpUser(userModel);
    });
  }

   @override
  Future<Either<Failure, Unit>> resetPassword(payloadEntity data) async {
    final payloadEntity userModel =
        payloadEntity(email: data.email, password: data.password,token: data.token);   
        return await _getMessage(() {
           return userRemoteDataSource.ResetPassword(data);
    });
  }

    @override
  Future<Either<Failure, Unit>> VerifyEmail(String code,String email) async {
      return await _getMessage(() {
           return userRemoteDataSource.verifyUser(code,email);
    });
  }

     @override
  Future<Either<Failure, Unit>> forgetPassword(String email) async {
    print("userepo");
      return await _getMessage(() {
           return userRemoteDataSource.ForgetPassword(email);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(AddOrVerifyUser addOrVerifyUser) async {
    if (await networtkInfo.isConnected) {
      try {
        await addOrVerifyUser();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

}

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/Core/Strings/constantes.dart';
import 'package:mobile/Core/failures/exception.dart';
import 'package:mobile/Features/Auth/data/model/UserModelLogin.dart';
import 'package:mobile/Features/Auth/domain/entities/login_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserModelLogin> signInUser(LoginEntity userModel);
  Future<Unit> signUpUser(LoginEntity userModel);
  Future<Unit> verifyUser(String code,String email);
  Future<void> signOutUser();
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {

  final http.Client client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModelLogin> signInUser(LoginEntity userModel) async {
    final body = jsonEncode(
          {"email": userModel.email, "password": userModel.password}
        );
    late final response;
    try {
      response = await client.post(Uri.parse(BASE_URL_BACKEND+"/auth/login"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: body);
    } catch (e) {
      print("exception " + e.toString());
    }

    if (response.statusCode == 200) {
      try {
        final user = UserModelLogin.fromJson(jsonDecode(response.body));
        return Future.value(user);
      } catch (e) {
        return Future.value(null);
      }
    } else {
      throw LoginException();
    }
  }

  @override
  Future<void> signOutUser() {
    throw UnimplementedError();
  }


  @override
  Future<Unit> signUpUser(LoginEntity userModel) async {
    final body = jsonEncode(
          {"email": userModel.email, 
           "password": userModel.password,
           "prenom":userModel.prenom,
           "nom":userModel.nom,
           "photo":userModel.photo
           }
        );
    late final response;
    try {
      response = await client.post(Uri.parse(BASE_URL_BACKEND+"/auth/register"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: body);
    } catch (e) {
      print("exception " + e.toString());
    }
    if (response.statusCode == 200) {
      try {
        return Future.value(unit);
      } catch (e) {
        return Future.value(null);
      }
    } else {
      throw RegisterException();
    }
  }


   @override
  Future<Unit> verifyUser(String code,String email) async {
    final body = jsonEncode(
          {"code":code,"email":email}
        );
    late final response;
    try {
      response = await client.post(Uri.parse(BASE_URL_BACKEND+"/auth/register"),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
          },
          body: body);
    } catch (e) {
      print("exception " + e.toString());
    }
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      try {
        print(response.body);
        return Future.value(response.body);
      } catch (e) {
        return Future.value(null);
      }
    } else {
      throw RegisterException();
    }
  }

}
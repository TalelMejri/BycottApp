import 'package:com.talel.boycott/Core/network/network_info.dart';
import 'package:com.talel.boycott/Features/Auth/data/datasource/user_local_data_source.dart';
import 'package:com.talel.boycott/Features/Auth/data/datasource/user_remote_data_source.dart';
import 'package:com.talel.boycott/Features/Auth/data/repositories/user_repo.dart';
import 'package:com.talel.boycott/Features/Auth/domain/repositories/UserRepository.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/forget_password_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/get_cached_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/reset_password_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/sign_in_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/sign_out_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/sign_up_user.dart';
import 'package:com.talel.boycott/Features/Auth/domain/usecases/verify_email_user.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:com.talel.boycott/Features/Auth/presentation/bloc/signup/signup_bloc.dart';
import 'package:com.talel.boycott/Features/Categorie/Presentation/bloc/Category/category_bloc.dart';
import 'package:com.talel.boycott/Features/Categorie/Presentation/bloc/RequestCategory/request_category_bloc.dart';
import 'package:com.talel.boycott/Features/Categorie/Presentation/bloc/accept_reject_category/accept_category_bloc_bloc.dart';
import 'package:com.talel.boycott/Features/Categorie/Presentation/bloc/add_delete_update_category/adddeleteupdate_category_bloc.dart';
import 'package:com.talel.boycott/Features/Categorie/data/dataressource/category_local_data_source.dart';
import 'package:com.talel.boycott/Features/Categorie/data/dataressource/category_remote_data_source.dart';
import 'package:com.talel.boycott/Features/Categorie/data/repositories/category_repository.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/repositories/CategoryRepository.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/UpdateCategory.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/accept_category.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/addCategory.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/deleteCategory.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/get_all.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/get_all_request.dart';
import 'package:com.talel.boycott/Features/Categorie/domain/usecases/reject_category.dart';
import 'package:com.talel.boycott/Features/Product/Presentation/bloc/Product/product_bloc.dart';
import 'package:com.talel.boycott/Features/Product/Presentation/bloc/add_delete_update_product/adddeleteupdate_product_bloc.dart';
import 'package:com.talel.boycott/Features/Product/Presentation/bloc/reject_accept_product/reject_accept_product_bloc.dart';
import 'package:com.talel.boycott/Features/Product/data/dataressource/product_remote_data_source.dart';
import 'package:com.talel.boycott/Features/Product/data/dataressource/product_local_data_source.dart';
import 'package:com.talel.boycott/Features/Product/data/repositories/Product_repository.dart';
import 'package:com.talel.boycott/Features/Product/domain/repositories/ProductRepository.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/Accept_Product.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/CheckExisteCodeBar.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/Reject_Poduct.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/UpdateProduct.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/addProduct.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/deleteProduct.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/get_all.dart';
import 'package:com.talel.boycott/Features/Product/domain/usecases/get_products_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //bloc
  sl.registerFactory(() => CategoryBloc(getAllCategory: sl()));

  sl.registerFactory(() => RequestBloc(getAllRequestCategory: sl()));

  sl.registerFactory(() => AdddeleteupdateCategoryBloc(
      addCategory: sl(), updateCategory: sl(), deleteCategory: sl()));

  sl.registerFactory(
      () => AcceptCategoryBlocBloc(acceptCategory: sl(), rejectCategory: sl()));

  sl.registerFactory(() => ProductBloc(getAllProduct: sl(),checkProduct: sl()));

  sl.registerFactory(() => RejectAcceptProductBloc(getAllRequestProduct: sl()));

  sl.registerFactory(() => AdddeleteupdateProductBloc(
      addProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      acceptProduct: sl(),
      rejectproduct: sl()));

  sl.registerFactory(
      () => AuthBloc(signInUserUseCase: sl(), signOutUserUseCase: sl()));

  sl.registerFactory(() => SignupBloc(
      signUpUserUseCase: sl(),
      verifyEmailUseCase: sl(),
      forgetPasswordUseCase: sl(),
      resetPasswordUserUseCase: sl()));

  //usecases
  sl.registerLazySingleton(() => GetAllCategoryUsecase(sl()));
  sl.registerLazySingleton(() => GetAllRequestUsecase(sl()));
  sl.registerLazySingleton(() => AddCategoryUsecase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUsecase(sl()));
  sl.registerLazySingleton(() => AcceptCategoryUsecase(sl()));
  sl.registerLazySingleton(() => RejectCategoryUsecase(sl()));

  sl.registerLazySingleton(() => GetAllProductUsecase(sl()));
  sl.registerLazySingleton(() => GetAllRequestProductUsecase(sl()));
  sl.registerLazySingleton(() => CheckProductUsecase(sl()));
  sl.registerLazySingleton(() => AddProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => RejectProductUsecase(sl()));
  sl.registerLazySingleton(() => AcceptProductUsecase(sl()));

  sl.registerLazySingleton(() => SignInUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

  sl.registerLazySingleton(() => SignUpUserUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUserUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUserUseCase(sl()));

  //repository
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      userLocalDataSource: sl(),
      userRemoteDataSource: sl(),
      networtkInfo: sl()));

  //Datasources
  sl.registerLazySingleton<CatyegoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:navy_admin/services/auth_service.dart';
import 'package:navy_admin/services/car_service.dart';
import 'package:navy_admin/services/token_service.dart';
import 'package:navy_admin/services/user_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: "https://navy-backend.onrender.com/api"));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add JWT token to request headers
        final token = await locator<TokenService>().getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    return dio;
  });

  locator.registerLazySingleton<AuthService>(() => AuthService(locator<Dio>()));
  locator.registerLazySingleton<TokenService>(() => TokenService());
  locator.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  locator.registerLazySingleton<UserService>(() => UserService(locator<Dio>()));
  locator.registerLazySingleton<CarService>(() => CarService(locator<Dio>()));
}
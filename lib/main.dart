import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/MyApp.dart';
import 'package:navy_admin/pages/Home.dart';
import 'package:navy_admin/pages/Login.dart';
import 'package:navy_admin/pages/users/listar_usuarios.dart';
import 'package:navy_admin/provider/auth_provider.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/car_service.dart';
import 'package:navy_admin/services/user_service.dart';
import 'package:navy_admin/viewmodels/FormUser_viewmodel.dart';
import 'package:navy_admin/viewmodels/Login_viewmodel.dart';
import 'package:navy_admin/viewmodels/form_car_viewmodel.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';


void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        // Provider para Dio
        Provider<Dio>(
          create: (_) => Dio(BaseOptions(baseUrl: 'https://navy-backend.onrender.com/api')),
        ),
        // Provider para AuthService, recebendo Dio
        Provider<AuthService>(
          create: (context) => AuthService(
            Provider.of<Dio>(context, listen: false),
          ),
        ),
        // Provider para AuthProvider, recebendo AuthService
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FormUserViewmodel(),
        ),
        ChangeNotifierProvider(
          create: (_) => FormCarViewmodel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
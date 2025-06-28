import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/pages/Home.dart';
import 'package:navy_admin/pages/Login.dart';
import 'package:navy_admin/pages/cars/form_car.dart';
import 'package:navy_admin/pages/cars/list_cars.dart';
import 'package:navy_admin/pages/users/Form_user.dart';
import 'package:navy_admin/pages/users/listar_usuarios.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navy Admin',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/users/form': (context) => FormUser(),
        '/users': (context) => ListarUsuarios(),
        '/cars': (context) => ListarCarros(),
        '/cars/form': (context) => FormCar(),
      },

    );
  }
}
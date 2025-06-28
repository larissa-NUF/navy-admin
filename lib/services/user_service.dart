import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/token_service.dart';

class UserService {
  Dio _dio = Dio();
  UserService(this._dio);

  Future<List<User>> GetAll() async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return [];

      final response = await _dio.get(
        '/users',
      );
      print(response);

      if (response.statusCode == 200) {
        return response.data.map<User>((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
    }

    return [];
  }

  Future<User?> GetUserById(String id) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return null;

      final response = await _dio.get(
        '/users/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response);

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
    } catch (e) {
      print('Erro ao buscar usuário por ID: $e');
    }

    return null;
  }

  Future<bool> Add(FormData user) async {
    try {
      final token = await locator<TokenService>().getToken();

      final response = await _dio.post(
        '/users/client',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
        data: user,
      );

      if (response.statusCode == 200) {
        print("Usuário salvo com sucesso.");
        return true;
      } else {
        print("Erro: Código de status ${response.statusCode}");
        print("Resposta: ${response.data}");
        return false;
      }
    } on DioException catch (dioError) {
      print("Erro de Dio:");
      print("Código de status: ${dioError.response?.statusCode}");
      print("Dados da resposta: ${dioError.response?.data}");
      print("Mensagem de erro: ${dioError.message}");
      return false;
    } catch (e) {
      print("Erro inesperado ao adicionar usuário: $e");
      return false;
    }
  }

  Future<bool> Delete(String id) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return false;

      final response = await _dio.delete(
        '/users/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Usuário deletado com sucesso.");
        return true;
      } else {
        print("Erro ao deletar usuário: Código de status ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro ao deletar usuário: $e");
      return false;
    }
  }

  Future<bool> Update(String id, FormData user) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return false;

      final response = await _dio.put(
        '/users/$id',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
        data: user,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Usuário atualizado com sucesso.");
        return true;
      } else {
        print("Erro ao atualizar usuário: Código de status ${response.statusCode}");
        print("Resposta: ${response.data}");
        return false;
      }
    } on DioException catch (dioError) {
      print("Erro de Dio ao atualizar usuário:");
      print("Código de status: ${dioError.response?.statusCode}");
      print("Dados da resposta: ${dioError.response?.data}");
      print("Mensagem de erro: ${dioError.message}");
      return false;
    } catch (e) {
      print("Erro inesperado ao atualizar usuário: $e");
      return false;
    }
  }

  Future<List<User>> GetByFilter(Map<String, dynamic> filters) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return [];

      // Monta a query string a partir do mapa de filtros
      final queryParameters = <String, dynamic>{};
      filters.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          queryParameters[key] = value;
        }
      });

      final response = await _dio.get(
        '/users/filter',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response);

      if (response.statusCode == 200) {
        return (response.data as List)
            .map<User>((json) => User.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Erro ao buscar usuários por filtro: $e');
    }

    return [];
  }
}
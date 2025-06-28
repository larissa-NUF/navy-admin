import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:navy_admin/modal/car.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/token_service.dart';

class CarService {
  Dio _dio = Dio();
  CarService(this._dio);

  Future<List<Car>> GetAll() async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return [];

      final response = await _dio.get(
        '/cars',
      );
      print(response);

      if (response.statusCode == 200) {
        return response.data.map<Car>((json) => Car.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar carros: $e');
    }

    return [];
  }

  Future<Car?> GetCarById(String id) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return null;

      final response = await _dio.get(
        '/cars/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response);

      if (response.statusCode == 200) {
        return Car.fromJson(response.data);
      }
    } catch (e) {
      print('Erro ao buscar carro por ID: $e');
    }

    return null;
  }

  Future<bool> Add(FormData car) async {
    try {
      final token = await locator<TokenService>().getToken();

      final response = await _dio.post(
        '/cars',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
        data: car,
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
        '/cars/$id',
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

  Future<bool> Update(String id, FormData car) async {
    try {
      final token = await locator<TokenService>().getToken();
      if (token == null) return false;

      final response = await _dio.put(
        '/cars/$id',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
        data: car,
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

  Future<List<Car>> GetByFilter(Map<String, dynamic> filters) async {
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
        '/cars/filter',
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
            .map<Car>((json) => Car.fromJson(json))
            .toList();
      }
    } catch (e) {
      print('Erro ao buscar carros por filtro: $e');
    }

    return [];
  }
}
import 'dart:developer';

import 'package:get/get.dart';

import '../models/user_model.dart';

class UserRepository {
  final restClient = GetConnect(timeout: const Duration(milliseconds: 600));

  UserRepository() {
    restClient.httpClient.baseUrl = 'http://192.168.0.5:8080';
    // restClient.httpClient.errorSafety = false;

    restClient.httpClient.addRequestModifier<Object?>((request) {
      log('URL que está sendo chamada: ${request.url.toString()}');
      request.headers['start-time'] = DateTime.now().toIso8601String();
      return request;
    });

    restClient.httpClient.addResponseModifier((request, response) {
      response.headers?['end-time'] = DateTime.now().toIso8601String();
      return response;
    });
  }

  Future<List<UserModel>> findAll() async {
    final result = await restClient.get('/users');

    if (result.hasError) {
      throw Exception('Erro ao buscar usuário (${result.statusText})');
    }

    log(result.request?.headers['start-time'] ?? '');
    log(result.headers?['end-time'] ?? '');

    return result.body
        .map<UserModel>((user) => UserModel.fromMap(user))
        .toList();
  }

  // Future<List<UserModel>> findAll() async {
  //   // // O DECODER SEMPRE SERÁ CHAMADO MESMO SE SUA RESPOSTA TIVER BODY OU NÃO ********
  //   // // NÃO É RECOMENDADO UTILIZAR!!! RAHMAN *****************************************
  //   final result = await restClient.get(
  //     '/users', decoder: (data) {
  //       return data.map<UserModel>((user) => UserModel.fromMap(user)).toList();
  //     },);
  //   if (result.hasError) {throw Exception('Erro ao buscar usuário (${result.statusText})');}
  //   return result.body ?? [];
  // }
  // // //

  Future<void> save(UserModel user) async {
    final result = await restClient.post('/users', user.toMap());

    if (result.hasError) {
      throw Exception('Erro ao salvar usuário (${result.statusText})');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    final result = await restClient.delete('/users/${user.id}');

    if (result.hasError) {
      throw Exception('Erro ao deletar usuário (${result.statusText})');
    }
  }

  Future<void> updateUser(UserModel user) async {
    final result = await restClient.put('/users/${user.id}', user.toMap());

    if (result.hasError) {
      throw Exception('Erro ao atualizar usuário (${result.statusText})');
    }
  }
}

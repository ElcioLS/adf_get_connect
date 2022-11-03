import 'package:get/get.dart';

import '../models/user_model.dart';

class UserRepository {
  final restClient = GetConnect();

  Future<List<UserModel>> findAll() async {
    final result = await restClient.get('http://192.168.0.5:8080/users');

    if (result.hasError) {
      throw Exception('Erro ao buscar usuário (${result.statusText})');
    }

    return result.body
        .map<UserModel>((user) => UserModel.fromMap(user))
        .toList();
  }

  Future<void> save(UserModel user) async {
    final result =
        await restClient.post('http://192.168.0.5:8080/users', user.toMap());

    if (result.hasError) {
      throw Exception('Erro ao salvar usuário (${result.statusText})');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    final result =
        await restClient.delete('http://192.168.0.5:8080/users/${user.id}');

    if (result.hasError) {
      throw Exception('Erro ao deletar usuário (${result.statusText})');
    }
  }

  Future<void> updateUser(UserModel user) async {
    final result = await restClient.put(
        'http://192.168.0.5:8080/users/${user.id}', user.toMap());

    if (result.hasError) {
      throw Exception('Erro ao atualizar usuário (${result.statusText})');
    }
  }
}
